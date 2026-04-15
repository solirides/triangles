extends Node2D

@export var collision_shapes:Array[Node] = []
@export var polygons:Array[Node] = []
@export var entrance_gradient:Node  = null
@export var exit_gradient:Node = null

@onready var world = $".."

signal boundary_changed(shapes:Array)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	change_level_collisions("start")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func change_level_collisions(state:String):
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
	
	#call_deferred("boundary_changed.emit")
	#boundary_changed.emit()

#func _on_area_2d_body_entered(body: Node2D) -> void:
	#if body.is_in_group("enemy_projectile"):
		#body.queue_free()

func _on_exit_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		GameManager.advance_game_stage(GameManager.GAME_STAGE.ROOM_MAP)

func _on_entrance_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		change_level_collisions("combat")
		world.start_level()
