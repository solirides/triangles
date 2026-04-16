extends Enemy

@export_group("Enemy")

@export var attack_duration:float = 0.7
@export var attack_frequency:float = 10
@export var attack_spread:float = 1

@export var separation_weight = 0.5

@onready var state_timer = $StateTimer

#var hop_frame_speed:int = max(int(floor(hop_speed * Engine.physics_ticks_per_second)), 1)

var stored_target_position:Vector2 = Vector2.ZERO

func _init():
	enemy_type = EnemyType.REPEATER
	#print(movement_speed)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.linear_damp = 4.0
	#state_timer.start(0.1)
	#movement_speed = 300
	#projectile_speed = 400
	#print(hop_frame_speed)


func attack():
	for i in int(attack_duration * attack_frequency):
		await get_tree().create_timer(1/attack_frequency, true, true).timeout
		shoot((target.global_position - self.global_position).rotated(randf_range(-attack_spread, attack_spread)), 100, 0)

func track_target():
	if target != null:
		stored_target_position = target.global_position

#func hop():
	#if target != null:
		#var vec = (stored_target_position - self.global_position).normalized()
		#self.apply_central_impulse(vec * hop_impulse * mass)
		#self.rotate(vec.angle())

func random_walk():
	#var vec = Vector2(0,0)
	var directions = [Vector2(1,0), Vector2(1,1), Vector2(0,1), Vector2(-1,1), Vector2(-1,0), Vector2(-1,-1), Vector2(0,-1), Vector2(1,-1)]
	var vec = directions[randi_range(0,7)]
	apply_central_impulse(vec * 400 * mass)

func separation_accel(state: PhysicsDirectBodyState2D):
	var view_range = 300
	for node in get_tree().get_nodes_in_group("enemy"):
		var vec = self.global_position - node.global_position
		if vec.length() < view_range:
			state.linear_velocity += (vec.normalized() * (1 - vec.length()/view_range) * separation_weight * movement_speed * mass)

func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	if target != null:
		var vec = (stored_target_position - self.global_position).normalized()
		state.linear_velocity = vec * movement_speed
		#self.rotate(vec.angle())
		
	separation_accel(state)
	

func _on_body_entered(body: Node2D) -> void:
	_on_collision(body)
#
#func _on_area_2d_body_entered(body: Node2D) -> void:
	#_on_collision(body)

func _on_state_timer_timeout() -> void:
	# predelay
	await get_tree().create_timer(state_pre_delays[enemy_type]).timeout
	
	match enemy_state:
		EnemyState.NONE:
			enemy_state = EnemyState.TRACK
		EnemyState.TRACK:
			track_target()
			enemy_state = EnemyState.MOVE
		EnemyState.MOVE:
			#hop()
			#separation_accel()
			enemy_state = EnemyState.ATTACK
		EnemyState.ATTACK:
			attack()
			enemy_state = EnemyState.RANDOM_MOVE
		EnemyState.RANDOM_MOVE:
			enemy_state = EnemyState.TRACK
			#var random_walk_period = 0.3
			#for i in int(random_walk_time / random_walk_period):
				#await get_tree().create_timer(random_walk_period, true, true).timeout
				#random_walk()
	
	state_timer.start(state_post_delays[enemy_type])
