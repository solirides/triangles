extends Control



@onready var card_hand:Node = $DynamicCardHand
@onready var deck:Node = $CardDeck

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
	check_combination([card_hand, deck])


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
		swap_cards(selections[0], selections[1])

func swap_cards(card_1:Node, card_2:Node):
	print("swap cards")
	var p1 = card_1.get_parent()
	var p2 = card_2.get_parent()
	var i1 = card_1.get_index()
	var i2 = card_2.get_index()
	var pos1 = card_1.global_position
	var pos2 = card_2.global_position
	
	if card_1.position_tween:
		print("kill")
		card_1.position_tween.kill()
	if card_2.position_tween:
		print("kill")
		card_2.position_tween.kill()
	
	if card_1.position_placeholder:
		print("kill p")
		card_1.position_placeholder.queue_free()
	if card_2.position_placeholder:
		print("kill p")
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
