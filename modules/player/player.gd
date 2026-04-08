extends RigidBody2D

@export_group("Movement")
@export var accel = 1
@export var decel = 0.3
@export var base_speed = 400
@export var drag = 0.1
@export var aim_speed_multiplier = 0.6
@export_category("Attack")
@export var base_health:int = 100
@export var projectile_speed = 1000
@export var projectile_lifetime = 3
@export var damage_immunity_time = 0.3
@export var attack_cooldown = 60/120.0

@export_group("Nodes")
@export var pivot:Node = null
@export var display:Node = null
@export var immunity_timer:Timer = null
@onready var attack_cooldown_timer:Timer = $Attack
@onready var raycast:RayCast2D = $Pivot/RayCast2D
#@onready var laser_polygon:Polygon2D = $Pivot/Laser
@export var camera_controller:Node = null

var speed = base_speed
var health = base_health
var projectile = preload("res://modules/projectile/player_projectile.tscn")
var turret = preload("res://modules/enemy/turret.tscn")
var hopper = preload("res://modules/enemy/hopper.tscn")
var laser_polygon = preload("res://modules/projectile/laser.tscn")

#var velocity = Vector2.ZERO
enum CONSTRUCTION_STATE {
	NONE,
	SEGMENT_0,
	SEGMENT_1,
	SEGMENT_2,
	CIRCLE_0,
	CIRCLE_1,
	CIRCLE_2
}
var construction_state = CONSTRUCTION_STATE.SEGMENT_0
var current_shape = []
var shapes = []
var build_state = BUILD_STATE.NONE
enum BUILD_STATE {
	NONE,
	PARTIAL,
	COMPLETE
}

# temporary immunity to enemy attacks
var damage_immunity = false
var movement_input = true
var aiming = false

func _ready() -> void:
	GameManager.player = self
	
	attack_cooldown_timer.wait_time = attack_cooldown
	immunity_timer.wait_time = damage_immunity_time
	
	#laser_polygon.scale.y = 0

func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	var vec = Input.get_vector("move_left","move_right","move_up","move_down")
	vec = vec.normalized()
	#linear_velocity += vec * accel * delta
	#linear_velocity = lerp(linear_velocity, Vector2.ZERO, drag)
	#self.position += velocity
	#self.position += vec * speed * delta
	# move at const velocity (no delta needed)
	#print(vec)
	if vec == Vector2.ZERO:
		#print("not moving")
		state.linear_velocity = state.linear_velocity.lerp(Vector2.ZERO, decel)
		#print(state.linear_velocity)
	else:
		#print("moving")
		state.linear_velocity = vec * speed
	#integrate_forces()


@onready var aim_tween = get_tree().create_tween()

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("secondary"):
		# set aiming = true after delay
		$Aim.start(0.2)
		#$Aim.timeout.connect(func(): aiming = true)
		speed = base_speed * aim_speed_multiplier
		# animate camera zoom
		aim_tween.kill()
		aim_tween = get_tree().create_tween()
		aim_tween.tween_property(camera_controller.camera, "zoom", Vector2(1.3,1.3), 0.3).set_trans(Tween.TRANS_SINE)
		#camera.camera.zoom = 
	if Input.is_action_just_released("secondary"):
		$Aim.stop()
		aiming = false
		speed = base_speed
		# animate camera zoom
		#var tween = get_tree().create_tween()
		aim_tween.kill()
		aim_tween = get_tree().create_tween()
		aim_tween.tween_property(camera_controller.camera, "zoom", Vector2(1,1), 0.12).set_trans(Tween.TRANS_SINE)
		#camera.camera.zoom = Vector2(1,1)
	
	if Input.is_action_pressed("special2"):
		if attack_cooldown_timer.time_left == 0:
			attack_cooldown_timer.start()
			var direction = (get_global_mouse_position()-self.global_position).normalized()
			shoot(direction, projectile_speed)
		
	if Input.is_action_pressed("primary"):
		if attack_cooldown_timer.time_left == 0:
			attack_cooldown_timer.start()
			var direction = (get_global_mouse_position()-self.global_position).normalized()
			var spread = 0.1
			for i in range(-2,3):
				shoot(direction.rotated(i * spread,), projectile_speed*3 * randf_range(0.8,1.0), 7.0)
	
	if Input.is_action_pressed("special1"):
		if attack_cooldown_timer.time_left == 0:
			attack_cooldown_timer.start()
			raycast.force_raycast_update()
			var hit = false
			while raycast.is_colliding():
				var collider = raycast.get_collider()
				raycast.add_exception(collider)
				
				if collider.is_in_group("enemy_projectile"):
					collider.queue_free()
					hit = true
				elif collider.is_in_group("enemy"):
					collider.damage(50)
					hit = true
				raycast.force_raycast_update()
			raycast.clear_exceptions()
			if hit:
				camera_controller.shake(0.16, 14, 20, 0)
			
			var a = laser_polygon.instantiate()
			a.scale.y = 0
			a.global_position = pivot.global_position
			a.global_rotation = pivot.global_rotation
			get_tree().get_current_scene().add_child(a)
			
			var tween = self.create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
			tween.tween_property(a, "scale", Vector2(1,1), 0.03)
			tween.tween_property(a, "scale", Vector2(1,1), 0.26)
			tween.tween_property(a, "modulate", Color(1,1,1,0), 0.03)
			tween.tween_property(a, "modulate", Color(1,1,1,1), 0.03)
			tween.tween_property(a, "scale", Vector2(1,0), 0.04)
			tween.tween_callback(a.queue_free)
	
	if Input.is_action_just_pressed("construct"):
		match construction_state:
			CONSTRUCTION_STATE.SEGMENT_0:
				current_shape.resize(3)
				current_shape[0] = "segment"
				current_shape[1] = self.global_position
				construction_state = CONSTRUCTION_STATE.SEGMENT_1
				build_state = BUILD_STATE.PARTIAL
			CONSTRUCTION_STATE.SEGMENT_1:
				current_shape[2] = self.global_position
				write_shape(current_shape)
				current_shape = []
				construction_state = CONSTRUCTION_STATE.SEGMENT_0
				BUILD_STATE.COMPLETE
			CONSTRUCTION_STATE.SEGMENT_2:
				pass
			_:
				pass
	
	if Input.is_action_just_pressed("spawn"):
		var a = turret.instantiate()
		a.position = get_global_mouse_position()
		get_tree().get_current_scene().add_child(a)
	if Input.is_action_just_pressed("spawn2"):
		var a = hopper.instantiate()
		a.target = GameManager.player
		a.position = get_global_mouse_position()
		get_tree().get_current_scene().add_child(a)

func _process(delta: float) -> void:
	var pos = get_global_mouse_position()
	pivot.look_at(pos)
	if build_state == BUILD_STATE.PARTIAL:
		display.draw_shape_progress = true
		display.shape_progress(current_shape)
	else:
		display.draw_shape_progress = false

func write_shape(data:Array):
	display.shapes.append(data)

func _on_area_2d_body_entered(body: Node2D) -> void:
	#print("collide")
	if body.is_in_group("enemy_projectile"):
		if damage(10):
			body.queue_free()
	if body.is_in_group("enemy"):
		print("enemy collision")

var tween
func on_hit():
	if tween != null:
		tween.kill()
	tween = create_tween()
	tween.set_trans(Tween.TRANS_SINE)
	var t = 0
	while t < damage_immunity_time:
		tween.tween_property(self, "modulate", Color(1,1,1,0), 0.04)
		tween.tween_property(self, "modulate", Color.WHITE, 0.04)
		t += 0.08

func damage(amount:int) -> bool:
	if damage_immunity == true:
		return false
	else:
		camera_controller.shake(0.24, 16, 20, 1)
		#print("player hit!")
		damage_immunity = true
		$Immunity.start()
		health -= amount
		print("player health:" + str(health))
		on_hit()
		if health <= 0:
			pass
		return true

func _on_invincibility_timeout() -> void:
	damage_immunity = false
	

func shoot(direction:Vector2, speed2, damp=0):
	var a = projectile.instantiate()
	a.position = self.position
	a.linear_velocity = direction * speed2
	a.linear_damp = damp
	#a.linear_velocity *= 1000
	#a.look_at(get_global_mouse_position())
	a.rotate(direction.angle())
	a.despawn_frame = projectile_lifetime * Engine.physics_ticks_per_second + Engine.get_physics_frames()
	get_tree().get_current_scene().add_child(a)

func dash(direction:Vector2, impulse, duration, damp):
	self.apply_central_impulse(direction * impulse)
	self.rotate(direction.angle())
	

func _on_aim_timeout() -> void:
	aiming = true
	
