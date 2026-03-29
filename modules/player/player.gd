extends Node2D

@export var accel = 1
@export var speed = 10
@export var drag = 0.1
@export var pivot:Node = null
@export var display:Node = null

var projectile = preload("res://modules/projectile/projectile.tscn")
var velocity = Vector2.ZERO
enum CONSTRUCTION_STATE {
	NONE,
	SEGMENT_0,
	SEGMENT_1,
	SEGMENT_2,
	CIRCLE_0,
	CIRCLE_1,
	CIRCLE_2
}
var construction_state = CONSTRUCTION_STATE.SEGMENT_0
var current_shape = []
var shapes = []
var build_state = BUILD_STATE.NONE
enum BUILD_STATE {
	NONE,
	PARTIAL,
	COMPLETE
}


func _physics_process(delta: float) -> void:
	var vec = Input.get_vector("move_left","move_right","move_up","move_down")
	vec = vec.normalized()
	velocity += vec * accel * delta
	velocity = lerp(velocity, Vector2.ZERO, drag)
	#self.position += velocity
	self.position += vec * speed
	
	if Input.is_action_just_pressed("primary"):
		var a = projectile.instantiate()
		get_tree().root.add_child(a)
		a.position = self.position
		a.linear_velocity = (get_global_mouse_position()-self.global_position).normalized()
		a.linear_velocity *= 1000
		a.look_at(get_global_mouse_position())
	
	if Input.is_action_just_pressed("construct"):
		match construction_state:
			CONSTRUCTION_STATE.SEGMENT_0:
				current_shape.resize(3)
				current_shape[0] = "segment"
				current_shape[1] = self.global_position
				construction_state = CONSTRUCTION_STATE.SEGMENT_1
				build_state = BUILD_STATE.PARTIAL
			CONSTRUCTION_STATE.SEGMENT_1:
				current_shape[2] = self.global_position
				write_shape(current_shape)
				current_shape = []
				construction_state = CONSTRUCTION_STATE.SEGMENT_0
				BUILD_STATE.COMPLETE
			CONSTRUCTION_STATE.SEGMENT_2:
				pass
			_:
				pass
		

func _process(delta: float) -> void:
	var pos = get_global_mouse_position()
	pivot.look_at(pos)
	if build_state == BUILD_STATE.PARTIAL:
		display.draw_shape_progress = true
		display.shape_progress(current_shape)
	else:
		display.draw_shape_progress = false

func write_shape(data:Array):
	display.shapes.append(data)
