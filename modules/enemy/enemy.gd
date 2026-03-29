extends RigidBody2D

@export var accel = 1000
@export var speed = 300

@export var player:Node

func _physics_process(delta: float) -> void:
	var vec = player.global_position - self.global_position
	vec = vec.normalized()
	linear_velocity += vec * accel * delta
	if linear_velocity.length() > speed:
		linear_velocity = linear_velocity.normalized() * speed
	
