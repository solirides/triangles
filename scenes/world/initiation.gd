extends Node2D


@export var level_size:Vector2 = Vector2(500, 300)

@onready var world_boundary = $StaticBody2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var collision_shape = CollisionShape2D.new()
	var shape = ConvexPolygonShape2D.new()
	
	var normal = [Vector2(0,-1), Vector2(1, 0), Vector2(0,1), Vector2(-1, 0)]
	
	#for i in range(4):
		#var shape = world_boundary.get_children()[i]
		#shape.shape.distance = -distance[i]
		#shape.shape.normal = normal[i]
		
	#world_boundary.get_children()[0].polygon = PackedVector2Array([Vector2(level_size.x, level_size.y), Vector2(-level_size.x, level_size.y), Vector2(-level_size.x, -level_size.y), Vector2(level_size.x, -level_size.y)])
	
	initiate_card_hand()
	
	GameManager.ready_state["world"] = true
	
	

func initiate_card_hand():
	print("generate cards")
	GameManager.card_hands.clear()
	var h = CardHand.new()
	for i in range(3):
		var c = ModifierCard.generate_card(1)
		h.modifier_cards.append(c)
	GameManager.card_hands.append(h)
	
	GameManager.card_hand_updated.emit()
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		GameManager.advance_game_stage(GameManager.GAME_STAGE.ROOM_MAP)
