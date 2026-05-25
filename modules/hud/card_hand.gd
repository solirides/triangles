extends HBoxContainer



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameManager.card_hand_updated.connect(_on_card_hand_updated)
	GameManager.player_node_ready.connect(_on_player_ready)
	GameManager.all_initial_nodes_ready.connect(_on_all_initial_nodes_ready)
	GameManager.active_hand_changed.connect(_on_active_hand_changed)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_player_ready():
	pass

func _on_all_initial_nodes_ready():
	update_gui_cards()

func _on_card_hand_updated():
	update_gui_cards()

func update_gui_cards():
	print("update gui cards")
	#print(GameManager.card_hands.size())
	#print(GameManager.active_card_hand_i)
	if GameManager.card_hands.size() <= GameManager.active_card_hand_i:
		return
	#print("actually update gui cards")
	
	for n in get_children():
		if n is GuiCard:
			n.queue_free()
	
	var h = GameManager.card_hands[GameManager.active_card_hand_i]
	for c in h.modifier_cards:
		var card = GuiCard.create_modifier_card(c)
		#print("add modifier card")
		add_child(card)
		#print(get_children().size())
	
	if h.modifier_cards.size() == 0:
		$Label.visible = true
	else:
		$Label.visible = false
	
	GameManager.player.recalculate_stats()
	
	

func _on_active_hand_changed(hand_i:int):
	update_gui_cards()
