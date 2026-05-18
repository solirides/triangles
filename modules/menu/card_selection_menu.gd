extends Control


@export var max_swaps = 2

@onready var card_hand:Node = $DynamicCardHand
@onready var deck:Node = $CardDeck

var swaps = 0
var action_mode = "swap"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#pass
	GameManager.initiate_card_hand()
	
	var level = GameManager.player_level
	
	for n in card_hand.get_children():
		n.queue_free()
	
	var h = GameManager.card_hands[GameManager.active_card_hand_i]
	for c in h.modifier_cards:
		var card = GuiCard.create_modifier_card(c)
		#print("add modifier card")
		card_hand.add_child(card)
		#print(get_children().size())
	#card_hand.call_deferred("arrange_hand", true)
	
	for c in generate_card_deck(level).modifier_cards:
		var card = GuiCard.create_modifier_card(c)
		deck.add_child(card)
	
	# wait for nodes to be updated
	await get_tree().process_frame
	card_hand.arrange_hand(true)
	deck.arrange_hand(true)

func generate_card_deck(level:int):
	var h = CardHand.new()
	for i in range(3):
		var c = ModifierCard.generate_card(level)
		h.modifier_cards.append(c)
	return h
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if swaps >= max_swaps and false:
		advance_game()
	var selections = check_combination([card_hand, deck])
	if action_mode == "swap":
		# if cards are from different hands
		if selections != null:
			#if selections[0].get_parent() != selections[1].get_parent() and swaps < max_swaps:
			if selections[0].get_parent() != selections[1].get_parent():
				swap_cards(selections[0], selections[1])
				swaps += 1
	elif action_mode == "merge":
		if selections != null:
			if selections[0].get_parent() == selections[1].get_parent():
				merge_cards(selections[0], selections[1])

func advance_game():
	update_card_hand(GameManager.active_card_hand_i)
	GameManager.advance_game_stage(GameManager.GameStage.COMBAT)

func update_card_hand(hand_i:int):
	var cards = []
	cards.append_array(card_hand.get_cards())
	
	var h = CardHand.new()
	for i in cards.size():
		h.modifier_cards.append(cards[i].modifier_card)
	GameManager.card_hands[hand_i] = h

func check_combination(parents:Array[Node]):
	#print("check_combination")
	var cards = []
	for p in parents:
		cards.append_array(p.get_cards())
	var selections = []
	#print(cards)
	for i in cards.size():
		if cards[i].picked:
			selections.append(cards[i])
			if selections.size() == 2:
				break
	#print(selections.size())
	if selections.size() == 2:
		selections[0].set_picked(false)
		selections[1].set_picked(false)
		return [selections[0], selections[1]]
	return null


func merge_cards(card_1:Node, card_2:Node):
	print("merge cards")
	var p1 = card_1.get_parent()
	var i1 = card_1.get_index()
	var pos1 = card_1.global_position
	
	
	var mc = ModifierCard.new()
	var og_modifiers = (card_1.modifier_card.modifiers + card_2.modifier_card.modifiers)
	
	for og_m in og_modifiers:
		# search if new card has modifier with same stat name
		var has_stat = false
		var stat_i
		for i in mc.modifiers.size():
			if mc.modifiers[i].stat == og_m.stat:
				print("match " + mc.modifiers[i].stat + " " + og_m.stat)
				has_stat = true
				stat_i = i
				break
		if has_stat:
			if mc.modifiers[stat_i].modifier_value <= 0 and og_m.modifier_value <= 0:
				# take minimum of negative modifier
				print("min modifier")
				mc.modifiers[stat_i].modifier_value = min(og_m.modifier_value, mc.modifiers[stat_i].modifier_value)
			elif mc.modifiers[stat_i].modifier_value > 0 and og_m.modifier_value > 0:
				# sum positive modifier
				print("sum modifier")
				mc.modifiers[stat_i].modifier_value += og_m.modifier_value
			else:
				print("delete modifier")
				mc.modifiers.remove_at(stat_i)
		else:
			# copy modifier to new card
			print("copy modifier")
			mc.modifiers.append(og_m.duplicate())
		
		#mc.description = ModifierCard.generate_description(mc)
		#print(mc.modifiers)
		#print(mc.description)
	
	mc.description = ModifierCard.generate_description(mc)
	print(mc.modifiers)
	print(mc.description)
	
	
	#for i in card.modifier_card.modifiers.size():
		#if card.modifier_card.modifiers[i].modifier_value <= 0:
			#card.modifier_card.modifiers[i].modifier_value = min(card_1.modifier_card.modifiers[i].modifier_value, card_2.modifier_card.modifiers[i].modifier_value)
		#else: 
			#card.modifier_card.modifiers[i].modifier_value = card_1.modifier_card.modifiers[i].modifier_value + card_2.modifier_card.modifiers[i].modifier_value
	#
	var card = GuiCard.create_modifier_card(mc)
	
	card.set_focus(false, true)
	card.set_picked(false, true)
	#card.dragged = card_1.dragged
	card.position = card_1.position
	card.rotation = card_1.rotation
	
	card_1.queue_free()
	card_2.queue_free()
	p1.add_child(card)
	p1.move_child(card, i1)
	card.set_global_position(pos1)
	
	#card.position_placeholder.queue_free()
	card.set_focus(false)
	await get_tree().process_frame
	p1.arrange_hand(true)
	
	# will trigger button toggled signal
	$Merge.button_pressed = false
	
	#action_mode = "swap"
	

func swap_cards(card_1:Node, card_2:Node):
	print("swap cards")
	var p1 = card_1.get_parent()
	var p2 = card_2.get_parent()
	var i1 = card_1.get_index()
	var i2 = card_2.get_index()
	var pos1 = card_1.global_position
	var pos2 = card_2.global_position
	
	if card_1.position_tween:
		#print("kill")
		card_1.position_tween.kill()
	if card_2.position_tween:
		#print("kill")
		card_2.position_tween.kill()
	
	if card_1.position_placeholder:
		#print("kill p")
		card_1.position_placeholder.queue_free()
	if card_2.position_placeholder:
		#print("kill p")
		card_2.position_placeholder.queue_free()
	
	card_1.reparent(p2, true)
	card_2.reparent(p1, true)
	
	p1.move_child(card_2, i1)
	p2.move_child(card_1, i2)
	
	card_1.set_global_position(pos1)
	card_2.set_global_position(pos2)
	
	#card_1.create_tween().tween_property(card_1, "global_position", pos1, 1.0)
	#card_2.create_tween().tween_property(card_2, "global_position", pos2, 1.0)
	#await get_tree().process_frame
	
	p1.arrange_hand(true)
	p2.arrange_hand(true)

func _on_button_pressed() -> void:
	advance_game()

#func _on_merge_pressed() -> void:
	#action_mode = "merge"

func _on_merge_toggled(toggled_on: bool) -> void:
	if toggled_on:
		action_mode = "merge"
	else:
		action_mode = "swap"
