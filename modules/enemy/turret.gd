extends Node2D

@export_group("Attack")
### full rotations per second
@export var rotation_speed = 1.0
### seconds per attack
@export var attack_speed = 0.05
### projectile speed
@export var projectile_speed = 300
### number of projectiles per attack
@export var pattern = 1

@export_group("Enemy")
@export var base_health:int = 20
@export var despawn_bullets_on_death:bool = false

var health = 0
var projectile = preload("res://modules/projectile/projectile.tscn")
#var frame_count = 0
#var last_attack = 0
#var last_attack_num = 0
var projectiles = []
@onready var start_time = Time.get_ticks_msec()
@onready var timer = $Timer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	timer.wait_time = attack_speed
	#timer.start()
	health = base_health

'''
methods for repeated attacks:
1. Simple add time delta
2. Compare to initial spawn time
3. Use timer
'''

func _physics_process(delta:float) -> void:
	#var ticks = Time.get_ticks_msec()
	#rotation = 2*PI * (ticks - start_time) / 1000.0 * rotation_speed
	rotation += 2*PI * delta
	if Engine.get_physics_frames() % 8 == 0:
		shoot()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	#rotation += 2*PI * delta
	#if ticks - last_attack > 0.05 * 1000:
	#var attack_num = floor(ticks / 1000.0 / attack_speed)
	#if attack_num > last_attack_num:
		#last_attack = ticks
		#last_attack_num = attack_num
		#shoot()

func shoot():
	for i in range(pattern):
		var a = projectile.instantiate()
		a.position = self.position
		a.linear_velocity = Vector2(1,0).rotated(rotation + 2*PI*i/pattern) * projectile_speed
		a.rotate(rotation)
		get_tree().root.add_child(a)
		projectiles.append(a)

func _on_timer_timeout() -> void:
	shoot()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player_projectile"):
		damage(10)
		body.queue_free()

func damage(amount:int):
	health -= amount
	if health <= 0:
		queue_free()

# called when this node is deleted
func _exit_tree():
	if despawn_bullets_on_death:
		for node in projectiles:
			node.queue_free()
	
