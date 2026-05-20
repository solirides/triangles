extends Node2D

@export var player:Node

@export var damage:float = 3
@export var attack_speed:float = 0.7
@export var projectile_speed:float = 0.6
@export var projectile_spread:float = 0.2
@export var damage_immunity_time:float = 4
@export var range:float = 100
#@export var angle:float = 2*PI*0.3

@onready var sword_area:Area2D = $"SwordArea"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$SwordArea/CollisionShape2D.shape.radius = range

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func attack():
	var cooldown_duration = 1.0 / (player.get_stat("attack_speed")*attack_speed)
	player.start_attack_cooldown(cooldown_duration)
	
	# immunity is overpowered
	#player.start_damage_immunity(player.get_stat("damage_immunity_time")*damage_immunity_time, false)
	
	for body in sword_area.get_overlapping_bodies():
		if body.is_in_group("enemy"):
			body.damage(player.get_stat("attack_damage")*damage)
			GameManager.player.camera_controller.shake(0.1, 10, 20, 0)
		elif body.is_in_group("enemy_projectile"):
			body.queue_free()
	
	GameManager.global_audio.play("slice")
	animate(cooldown_duration)

func _draw() -> void:
	draw_circle(Vector2(0,0), range, Color(0.689, 0.514, 0.97, 0.455), false, 1, true)

var tween
func animate(time:float):
	$Slash.global_rotation = player.pivot.global_rotation
	
	if tween:
		tween.kill()
	tween = create_tween()
	#tween.tween_method($Slash.material.set.bind("shader_parameter/lead_angle"), 0.0, 1.0, 1.0)
	tween.tween_method(set_slash_progress, 0.0, 2.0, time)

func set_slash_progress(value:float):
	$Slash.material.set("shader_parameter/lead_angle", value)
