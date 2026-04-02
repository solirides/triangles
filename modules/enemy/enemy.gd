class_name Enemy
extends Entity

@export_group("Enemy")
@export var target:Node = null
@export var movement_speed = 300
#### full rotations per second
#@export var rotation_speed = 1.0
#### seconds per attack
#@export var attack_speed = 0.05
#### projectile speed
@export var projectile_speed = 300
### number of projectiles per attack
#@export var pattern = 1
### projectile lifetime in seconds
@export var projectile_lifetime = 5
@export var despawn_bullets_on_death:bool = false

var projectile = preload("res://modules/projectile/projectile.tscn")
var projectiles = []
var projectile_times = []

#var attack_frame_speed:int = max(int(floor(attack_speed * 60)), 1)

var start_frame = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	start_frame = Engine.get_physics_frames()

#func _physics_process(delta:float) -> void:
	#var physics_frame = Engine.get_physics_frames()
	#rotation += 2*PI * delta
	#if physics_frame % attack_frame_speed == 0:
		#shoot(Vector2(1,0).rotated(rotation), projectile_speed, 0)
	#
	## delete projectiles if over max lifetime
	#for i in projectile_times.size():
		#if projectile_times[i][0] <= physics_frame:
			#if projectile_times[i][1] != null:
				#projectile_times[i][1].queue_free()
			#projectile_times.remove_at(i)
		#else:
			#break

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

#func shoot_pattern():
	#for i in range(pattern):
		#shoot(rotation + 2*PI*i/pattern, projectile_speed, 0)
		#

func shoot(direction:Vector2, speed2, damp=0):
	var a = projectile.instantiate()
	a.position = self.position
	a.linear_velocity = direction.normalized() * speed2
	a.linear_damp = damp
	a.rotate(direction.angle())
	get_tree().root.add_child(a)
	projectiles.append(a)
	projectile_times.append([Engine.get_physics_frames() + int(projectile_lifetime * 60), a])
	

func _on_collision(body: Node2D) -> void:
	if body.is_in_group("player_projectile"):
		damage(10)
		body.queue_free()

# called when this node is deleted
func _exit_tree():
	if despawn_bullets_on_death:
		for node in projectiles:
			node.queue_free()
	


#extends Entity
#
#@export var accel = 1000
#@export var speed = 300
#
#@export var player:Node
#
#func _physics_process(delta: float) -> void:
	#var vec = player.global_position - self.global_position
	#vec = vec.normalized()
	#linear_velocity += vec * accel * delta
	#if linear_velocity.length() > speed:
		#linear_velocity = linear_velocity.normalized() * speed
	#
