class_name Entity
extends RigidBody2D

@export_group("Entity")
@export var base_health:int = 100

@onready var health = base_health
@onready var start_time = Time.get_ticks_msec()

# Called when the node enters the scene tree for the first time.
#func _ready() -> void:

func damage(amount:int):
	health -= amount
	print(health)
	if health <= 0:
		queue_free()
