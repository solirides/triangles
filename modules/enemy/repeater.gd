extends Enemy

@export_group("Enemy")
#### seconds per hop
#@export var hop_speed = 1.0
#### delay between player tracking and hop in frames
#@export var hop_delay:int = 4

@export var state_delays:Dictionary = {
	
}

@onready var state_timer = $StateTimer

#var hop_frame_speed:int = max(int(floor(hop_speed * Engine.physics_ticks_per_second)), 1)

var stored_target_position:Vector2 = Vector2.ZERO

func _init():
	enemy_type = EnemyType.REPEATER

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.linear_damp = 4.0
	#state_timer.start(0.1)
	projectile_speed = 400
	#print(hop_frame_speed)


func _physics_process(delta: float) -> void:
	pass
	#print("gfdhjgds")
	#if target != null:
		##print("target")
		#var physics_frame = Engine.get_physics_frames() - start_frame
		##print((physics_frame + hop_delay) % hop_frame_speed)
		#if physics_frame % hop_frame_speed:
			#stored_target_position = target.global_position
		#elif (physics_frame + hop_delay) % hop_frame_speed:
			##print("hop")
			#var vec = (stored_target_position - self.global_position).normalized()
			#self.apply_central_impulse(vec * hop_impulse * mass)
			#self.rotate(vec.angle())
			#separation_accel()
			
	

func attack():
	for i in int(attack_duration * attack_frequency):
		await get_tree().create_timer(1/attack_frequency, true, true).timeout
		shoot((target.global_position - self.global_position).rotated(randf_range(-attack_spread, attack_spread)), 100, 0)

func track_target():
	if target != null:
		stored_target_position = target.global_position

func hop():
	if target != null:
		var vec = (stored_target_position - self.global_position).normalized()
		self.apply_central_impulse(vec * hop_impulse * mass)
		self.rotate(vec.angle())

func random_walk():
	#var vec = Vector2(0,0)
	var directions = [Vector2(1,0), Vector2(1,1), Vector2(0,1), Vector2(-1,1), Vector2(-1,0), Vector2(-1,-1), Vector2(0,-1), Vector2(1,-1)]
	var vec = directions[randi_range(0,7)]
	apply_central_impulse(vec * 400 * mass)

func separation_accel():
	var view_range = 300
	for node in get_tree().get_nodes_in_group("enemy"):
		var vec = self.global_position - node.global_position
		if vec.length() < view_range:
			self.apply_central_impulse(vec.normalized() * (1 - vec.length()/view_range) * separation_weight * hop_impulse * mass)

func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	pass

func _on_body_entered(body: Node2D) -> void:
	_on_collision(body)
#
#func _on_area_2d_body_entered(body: Node2D) -> void:
	#_on_collision(body)

func _on_state_timer_timeout() -> void:
	match enemy_state:
		EnemyState.NONE:
			enemy_state = EnemyState.TRACK
			state_timer.start(0.1)
		EnemyState.TRACK:
			track_target()
			state_timer.start(tracking_time)
			enemy_state = EnemyState.MOVE
		EnemyState.MOVE:
			hop()
			separation_accel()
			state_timer.start(hop_time)
			enemy_state = EnemyState.ATTACK
		EnemyState.ATTACK:
			attack()
			state_timer.start(attack_time)
			enemy_state = EnemyState.RANDOM_MOVE
		EnemyState.RANDOM_MOVE:
			state_timer.start(attack_time)
			enemy_state = EnemyState.TRACK
			for i in int(attack_time / 0.3):
				await get_tree().create_timer(0.3, true, true).timeout
				random_walk()
			
			
