extends Enemy


@export_group("Enemy")
@export var rotation_speed = 0.4
### seconds per attack
@export var attack_speed = 12/60.0
### number of projectiles per attack
@export var pattern = 1

var attack_frame_speed:int = max(int(floor(attack_speed * Engine.physics_ticks_per_second)), 1)

func _physics_process(delta:float) -> void:
	var physics_frame = Engine.get_physics_frames() - start_frame
	rotation += 2*PI * rotation_speed * delta
	if physics_frame % attack_frame_speed == 0:
		shoot(Vector2(1,0).rotated(rotation), projectile_speed, 0)
	
	# delete projectiles if over max lifetime
	for i in projectile_times.size():
		if projectile_times[i][0] <= physics_frame:
			if projectile_times[i][1] != null:
				projectile_times[i][1].queue_free()
			projectile_times.remove_at(i)
		else:
			break

func shoot_pattern():
	for i in range(pattern):
		shoot(rotation + 2*PI*i/pattern, projectile_speed, 0)
		
