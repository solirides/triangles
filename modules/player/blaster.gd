extends Node2D


@export var player:Node

@export var damage:float = 0.2
@export var attack_speed:float = 3
@export var projectile_speed:float = 0.7
@export var projectile_spread:float = 0.6

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	global_rotation = player.pivot.global_rotation

func attack():
	var cooldown_duration = 1.0 / (player.get_stat("attack_speed")*attack_speed)
	player.start_attack_cooldown(cooldown_duration)
	
	player.attack_cooldown_timer.start(1.0 / (player.get_stat("attack_speed")*attack_speed))
	var direction = (get_global_mouse_position()-self.global_position).normalized()
	player.shoot(direction.rotated(player.get_stat("projectile_spread")*projectile_spread * randf_range(-1,1)), player.get_stat("projectile_speed")*projectile_speed)
	GameManager.global_audio.play("shoot")
	
