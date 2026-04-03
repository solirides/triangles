extends Enemy


@export_group("Enemy")
@export var rotation_speed = 0.8
### seconds per attack
@export var attack_speed = 4/60.0
### number of projectiles per attack
@export var pattern = 1
### seconds between start of burst attacks
@export var burst_speed = 6
### seconds per burst attack
@export var burst_length = 80/60.0

@onready var burst_timer = $Burst
var burst_attacking = false

func _physics_process(delta:float) -> void:
	var physics_frame = Engine.get_physics_frames() - start_frame
	var attack_frame_speed:int = max(int(floor(attack_speed * Engine.physics_ticks_per_second)), 1)
	var burst_frame_speed:int = max(int(floor(burst_speed * Engine.physics_ticks_per_second)), 1)
	
	rotation += 2*PI * rotation_speed * delta
	
	if physics_frame % burst_frame_speed == 0:
		burst()
	
	if physics_frame % attack_frame_speed == 0 and burst_attacking:
		shoot(Vector2(1,0).rotated(rotation), projectile_speed, 0)
	

func burst():
	#print("start burst")
	burst_attacking = true
	burst_timer.wait_time = burst_length
	burst_timer.start()

func shoot_pattern(count:int):
	for i in range(count):
		shoot(Vector2(1,0).rotated(rotation + 2*PI*i/pattern), projectile_speed, 0)
		

func _on_burst_timeout() -> void:
	#print("stop burst")
	burst_attacking = false
