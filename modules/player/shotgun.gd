extends Node2D


@export var player:Node

@export var damage:float = 1.4
@export var attack_speed:float = 1
@export var projectile_speed:float = 1.4
@export var projectile_spread:float = 1
@export var shot_count:int = 3

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func attack():
	var cooldown_duration = 1.0 / (player.get_stat("attack_speed")*attack_speed)
	player.start_attack_cooldown(cooldown_duration)
	
	
	var direction = (get_global_mouse_position()-self.global_position).normalized()
	#var spread = 0.1
	
	var shots:int = round(player.get_stat("shot_count")*shot_count)
	#shots = 1
	var a = floor(shots / 2.0)
	#print(a)
	# offset by half of spread distance if even
	var even = (shots+1)%2
	var offset = even * player.get_stat("projectile_spread") * 0.5
	print(offset)
	for i in range(-a, a + 1 - even):
		player.shoot(direction.rotated(offset + i * player.get_stat("projectile_spread")), player.get_stat("projectile_speed")*projectile_speed * randf_range(0.9,1.0), 7.0, player.linear_velocity, player.get_stat("attack_damage")*damage)
	GameManager.global_audio.play("shotgun")
