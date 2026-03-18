extends Node2D

@export var accel = 1
@export var pivot:Node = null

var projectile = preload("res://modules/projectile/projectile.tscn")

var velocity = Vector2.ZERO

func _physics_process(delta: float) -> void:
	var vec = Input.get_vector("move_left","move_right","move_up","move_down")
	vec = vec.normalized()
	velocity += vec * accel
	velocity = lerp(velocity, Vector2.ZERO, 0.1)
	self.position += velocity
	

func _process(delta: float) -> void:
	var pos = get_global_mouse_position()
	pivot.look_at(pos)
