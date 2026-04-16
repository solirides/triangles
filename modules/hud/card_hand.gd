extends HBoxContainer

@export var card_scene = preload("res://modules/hud/card.tscn")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	GameManager.player_node_ready.connect(_on_player_ready)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_player_ready():
	print("generate cards")
	var c = card_scene.instantiate()
	c.modifier_card = ModifierCard.generate_card(1)
	c.icon
	add_child(c)
	GameManager.player.recalculate_stats()
