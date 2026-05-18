extends Node2D

@export var player:Node

@export var damage:float = 5
@export var attack_speed:float = 3
@export var projectile_speed:float = 0.6
@export var projectile_spread:float = 0.2
@export var damage_immunity_time:float = 4

@onready var sword_area:Area2D = $"SwordArea"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func attack():
	var cooldown_duration = 1.0 / (player.get_stat("attack_speed")*attack_speed)
	player.start_attack_cooldown(cooldown_duration)
	
	player.start_damage_immunity(player.get_stat("damage_immunity_time")*damage_immunity_time, false)
	
	for body in sword_area.get_overlapping_bodies():
		if body.is_in_group("enemy"):
			body.damage(player.get_stat("attack_damage")*damage)
			GameManager.player.camera_controller.shake(0.1, 10, 20, 0)
		elif body.is_in_group("enemy_projectile"):
			body.queue_free()
	

func _draw() -> void:
	draw_circle(Vector2(0,0), 90, Color(0.689, 0.514, 0.97, 0.455), false, 20, true)
