extends HBoxContainer

@export var card_scene = preload("res://modules/hud/card.tscn")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameManager.card_hand_updated.connect(_on_card_hand_updated)
	GameManager.player_node_ready.connect(_on_player_ready)
	GameManager.all_initial_nodes_ready.connect(_on_all_initial_nodes_ready)

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
	for n in get_children():
		n.queue_free()
	
	var h = GameManager.card_hands[GameManager.player.active_card_hand_i]
	for c in h.modifier_cards:
		#print("add modifier card")
		var card = card_scene.instantiate()
		card.modifier_card = c
		#card.icon
		add_child(card)
		#print(get_children().size())
	GameManager.player.recalculate_stats()
