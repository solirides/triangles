class_name Enemy
extends Entity

@export_group("Enemy")
@export var target:Node = null
@export var movement_speed = 320
#### projectile speed
@export var projectile_speed = 480
### projectile lifetime in seconds
@export var projectile_lifetime = 10
@export var despawn_bullets_on_death:bool = false

var projectile = preload("res://modules/projectile/projectile.tscn")
var projectile_particle = preload("res://modules/projectile/projectile_particle.tscn")
var projectiles = []
var projectile_times = []

@onready var start_frame = Engine.get_physics_frames()

enum EnemyType {
	NONE,
	HOPPER,
	TURRET,
	REPEATER
}

var enemy_type = EnemyType.NONE

var enemy_state = EnemyState.NONE

enum EnemyState {
	NONE,
	MOVE,
	RANDOM_MOVE,
	TRACK,
	ATTACK,
	RETREAT
}

const ENEMY_SCENES = {
	EnemyType.NONE: "",
	EnemyType.HOPPER: "res://modules/enemy/hopper.tscn",
	EnemyType.TURRET: "res://modules/enemy/turret.tscn",
	EnemyType.REPEATER: "res://modules/enemy/repeater.tscn"
	
}

@export var state_pre_delays:Dictionary = {
	EnemyState.NONE: 0.0,
	EnemyState.MOVE: 0.0,
	EnemyState.RANDOM_MOVE: 0.0,
	EnemyState.TRACK: 0.0,
	EnemyState.ATTACK: 0.0,
	EnemyState.RETREAT: 0.0
}

@export var state_post_delays:Dictionary = {
	EnemyState.NONE: 0.3,
	EnemyState.MOVE: 0.3,
	EnemyState.RANDOM_MOVE: 0.3,
	EnemyState.TRACK: 0.3,
	EnemyState.ATTACK: 0.3,
	EnemyState.RETREAT: 0.3
}

func _init() -> void:
	pass

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func shoot(direction:Vector2, speed2, damp=0):
	var a = projectile.instantiate()
	a.global_position = self.global_position
	a.linear_velocity = direction.normalized() * speed2
	a.linear_damp = damp
	a.rotate(direction.angle())
	#a.despawn_frame = projectile_lifetime * Engine.physics_ticks_per_second + Engine.get_physics_frames()
	a.despawn_frame = EnemyProjectile.calculate_despawn_frame(projectile_lifetime, speed2, GameManager.approximate_bounds.size, damp)
	get_tree().get_current_scene().add_child(a)
	#projectiles.append(a)
	#projectile_times.append([Engine.get_physics_frames() + int(projectile_lifetime * 60), a])
	

func _on_collision(body: Node2D) -> void:
	if body.is_in_group("player_projectile"):
		self.damage(body.attack_damage)
		var p = projectile_particle.instantiate()
		get_tree().get_current_scene().add_child(p)
		p.global_position = self.global_position
		p.emitting = true
		
		GameManager.player.camera_controller.shake(0.1, 10, 20, 0)
		body.queue_free()
	if body.is_in_group("player"):
		body.damage(10)

# called when this node is deleted
func _exit_tree():
	if despawn_bullets_on_death:
		for node in projectiles:
			node.queue_free()
	

func despawn_bullets():
	var physics_frame = Engine.get_physics_frames() - start_frame
	# delete projectiles if over max lifetime
	for i in projectile_times.size():
		if projectile_times[i][0] <= physics_frame:
			if projectile_times[i][1] != null:
				projectile_times[i][1].queue_free()
			projectile_times.remove_at(i)
		else:
			break
