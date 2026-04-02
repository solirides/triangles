class_name Entity
extends RigidBody2D

@export_group("Entity")
@export var base_health:int = 20

var health = 0

@onready var start_time = Time.get_ticks_msec()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	health = base_health

func damage(amount:int):
	health -= amount
	if health <= 0:
		queue_free()
