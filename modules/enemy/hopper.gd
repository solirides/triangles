#class_name Hopper
extends Enemy

@export_group("Enemy")
#### seconds per hop
#@export var hop_speed = 1.0
#### delay between player tracking and hop in frames
#@export var hop_delay:int = 4

#@export var tracking_time:float = 10/60.0
#@export var hop_time:float = 0.5
@export var random_walk_time:float = 2.5
@export var attack_duration:float = 0.7
@export var attack_frequency:float = 10
@export var attack_spread:float = 1

@export var separation_weight = 0.5
@export var hop_impulse = 780

#var state_timer:Timer
@onready var state_timer = $StateTimer

#var hop_frame_speed:int = max(int(floor(hop_speed * Engine.physics_ticks_per_second)), 1)

var stored_target_position:Vector2 = Vector2.ZERO

func _init():
	enemy_type = EnemyType.HOPPER
	
	var pre_delays = {
		EnemyState.NONE: 0.0,
		EnemyState.MOVE: 0.0,
		EnemyState.RANDOM_MOVE: 0.0,
		EnemyState.TRACK: 0.0,
		EnemyState.ATTACK: 0.0,
		EnemyState.RETREAT: 0.0
	}
	
	var post_delays = {
		EnemyState.NONE: 0.0,
		EnemyState.MOVE: 0.5,
		EnemyState.RANDOM_MOVE: 2.5,
		EnemyState.TRACK: 1/6.0,
		EnemyState.ATTACK: 2.5,
		EnemyState.RETREAT: 0.0
	}
	
	#state_pre_delays.merge(pre_delays, true)
	state_post_delays.merge(post_delays, true)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#state_timer = Timer.new()
	#state_timer.one_shot = true
	#add_child(state_timer)
	
	self.linear_damp = 4.0
	state_timer.start(0.1)
	#projectile_speed = 140
	#print(hop_frame_speed)

func _physics_process(delta: float) -> void:
	pass

func attack():
	for i in int(attack_duration * attack_frequency):
		await get_tree().create_timer(1/attack_frequency, true, true).timeout
		shoot((target.global_position - self.global_position).rotated(randf_range(-attack_spread, attack_spread)), projectile_speed, 0)

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
			hop()
			separation_accel()
			enemy_state = EnemyState.ATTACK
		EnemyState.ATTACK:
			attack()
			enemy_state = EnemyState.RANDOM_MOVE
		EnemyState.RANDOM_MOVE:
			enemy_state = EnemyState.TRACK
			var random_walk_period = 0.3
			for i in int(random_walk_time / random_walk_period):
				await get_tree().create_timer(random_walk_period, true, true).timeout
				random_walk()
	
	state_timer.start(state_post_delays[enemy_type])
	
