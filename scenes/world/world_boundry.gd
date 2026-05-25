extends Node2D

@export var collision_shapes:Array[Node] = []
@export var polygons:Array[Node] = []
@export var entrance_gradient:Node  = null
@export var exit_gradient:Node = null

@onready var world = $".."

var collision_state = ""

signal boundary_changed(shapes:Array)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	change_level_collisions("start")
	GameManager.all_initial_nodes_ready.connect(_on_all_initial_nodes_ready)

func _on_all_initial_nodes_ready():
	#print("worldboundary all nodes ready signal")
	update_compass()

func update_compass():
	match collision_state:
		"start":
			GameManager.update_compass.emit(true, $StaticBody2D/Start.global_position)
		"combat":
			GameManager.update_compass.emit(false, Vector2.ZERO)
		"end":
			GameManager.update_compass.emit(true, $StaticBody2D/End.global_position)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func change_level_collisions(state:String):
	print("change level collisions:" + state)
	collision_state = state
	
	for i in polygons:
		i.visible = false
	for i in collision_shapes:
		i.set_deferred("disabled", true)
	entrance_gradient.visible = false
	exit_gradient.visible = false
	
	match state:
		"start":
			polygons[0].visible = true
			collision_shapes[0].set_deferred("disabled", false)
			entrance_gradient.visible = true
			boundary_changed.emit([collision_shapes[0]])
		"combat":
			polygons[1].visible = true
			collision_shapes[1].set_deferred("disabled", false)
			boundary_changed.emit([collision_shapes[1]])
		"end":
			polygons[2].visible = true
			collision_shapes[2].set_deferred("disabled", false)
			exit_gradient.visible = true
			boundary_changed.emit([collision_shapes[2]])
		_:
			pass
	
	update_compass()
	
	#call_deferred("boundary_changed.emit")
	#boundary_changed.emit()

#func _on_area_2d_body_entered(body: Node2D) -> void:
	#if body.is_in_group("enemy_projectile"):
		#body.queue_free()

func _on_exit_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		GameManager.player_level += 1
		GameManager.advance_game_stage(GameManager.GameStage.CARD_UPGRADE)

func _on_entrance_body_entered(body: Node2D) -> void:
	print("player entered start trigger")
	if body.is_in_group("player") and world.level_started == false:
		change_level_collisions("combat")
		world.start_level()
