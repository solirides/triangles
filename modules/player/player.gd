extends RigidBody2D

@export_group("Movement")
@export var const_movement_velocity = true
@export var accel = 1
@export var movement_damping = 0.1
@export var decel = 0.3
@export var base_speed = 320
@export var drag = 0.1
@export var aim_speed_multiplier = 0.6
@export_category("Attack")
@export var base_health:int = 100
@export var base_attack_damage:int = 10
@export var projectile_speed:float = 1000
@export var projectile_lifetime:float = 3
@export var damage_immunity_time:float = 0.8
@export var base_attack_speed:float = 2

@export_group("Nodes")
@export var display:Node = null
@export var pivot:Node = null
@onready var immunity_timer:Timer = $Immunity
@onready var attack_cooldown_timer:Timer = $Attack
@onready var raycast:ShapeCast2D = $Pivot/ShapeCast2D
#@onready var laser_polygon:Polygon2D = $Pivot/Laser
@export var camera_controller:Node = null
@export var hud:Node = null
@export var menu:Node = null

@export var modifier_cards:Array[ModifierCard] = []

var speed = base_speed
var health = base_health
var attack_speed = base_attack_speed
var attack_damage = base_attack_damage

var projectile = preload("res://modules/projectile/player_projectile.tscn")
var turret = preload("res://modules/enemy/turret.tscn")
var hopper = preload("res://modules/enemy/hopper.tscn")
var laser_polygon = preload("res://modules/projectile/laser.tscn")

# temporary immunity to enemy attacks
var damage_immunity = false
var movement_input = true
var aiming = false

@onready var constructor = $Constructor

func _ready() -> void:
	GameManager.player = self
	
	attack_cooldown_timer.wait_time = 1 / attack_speed
	immunity_timer.wait_time = damage_immunity_time
	
	recalculate_stats()
	#laser_polygon.scale.y = 0

func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	#var vec = Input.get_vector("move_left","move_right","move_up","move_down")
	var vec = Input.get_vector("ui_left","ui_right","ui_up","ui_down")
	vec = vec.normalized()
	#linear_velocity += vec * accel * delta
	#linear_velocity = lerp(linear_velocity, Vector2.ZERO, drag)
	#self.position += velocity
	#self.position += vec * speed * delta
	
	#print(vec)
	if vec == Vector2.ZERO:
		#print("not moving")
		state.linear_velocity = state.linear_velocity.lerp(Vector2.ZERO, decel)
		#print(state.linear_velocity)
	else:
		#print("moving")
		if const_movement_velocity:
			# move at const velocity (no delta needed)
			state.linear_velocity = vec * speed
		else:
			state.apply_central_force(vec * mass * speed)
			#state.apply_central_force(mass * (vec * speed / movement_damping - linear_velocity * movement_damping))
			#state.linear_velocity = state.linear_velocity.lerp(Vector2.ZERO, movement_damping)
			# a = F/m = (f-d)/m = (f-(v*u))/m
			# a = 0 ==> f=(v*u)
			# v = f/u
			
	#integrate_forces()


@onready var aim_tween = get_tree().create_tween()

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("special1"):
		# set aiming = true after delay
		$Aim.start(0.2)
		#$Aim.timeout.connect(func(): aiming = true)
		speed = base_speed * aim_speed_multiplier
		# animate camera zoom
		aim_tween.kill()
		aim_tween = get_tree().create_tween()
		aim_tween.tween_property(camera_controller.camera, "zoom", Vector2(1.3,1.3), 0.3).set_trans(Tween.TRANS_SINE)
		#camera.camera.zoom = 
	if Input.is_action_just_released("special1"):
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
			attack_cooldown_timer.start(1 / attack_speed)
			var direction = (get_global_mouse_position()-self.global_position).normalized()
			shoot(direction, projectile_speed)
		
	if Input.is_action_pressed("primary"):
		if attack_cooldown_timer.time_left == 0:
			attack_cooldown_timer.start(1 / attack_speed)
			var direction = (get_global_mouse_position()-self.global_position).normalized()
			var spread = 0.1
			for i in range(-2,3):
				shoot(direction.rotated(i * spread,), projectile_speed*2 * randf_range(0.8,1.0), 7.0, self.linear_velocity)
			GameManager.global_audio.play("shoot")
	
	if Input.is_action_pressed("secondary"):
		if attack_cooldown_timer.time_left == 0:
			attack_cooldown_timer.start(1 / attack_speed)
			raycast.force_shapecast_update()
			var hit = false
			while raycast.is_colliding():
				for i in raycast.get_collision_count():
					var collider = raycast.get_collider(i)
					raycast.add_exception(collider)
					
					if collider.is_in_group("enemy_projectile"):
						collider.queue_free()
						hit = true
					elif collider.is_in_group("enemy"):
						collider.damage(50)
						hit = true
				raycast.force_shapecast_update()
			raycast.clear_exceptions()
			if hit:
				camera_controller.shake(0.16, 14, 20, 0)
			
			var a = laser_polygon.instantiate()
			a.scale.y = 0
			a.global_position = pivot.global_position + Vector2(20,0).rotated(pivot.global_rotation)
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
		#🔥🔥🔥
		constructor.construct()
	
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
		GameManager.global_audio.play("player_hit")
		camera_controller.shake(0.24, 16, 20, 1)
		#print("player hit!")
		damage_immunity = true
		$Immunity.start()
		health -= amount
		print("player health:" + str(health))
		on_hit()
		if health <= 0:
			game_over()
		return true

func game_over():
	GameManager.game_over()
	menu.game_over()
	
	

func _on_invincibility_timeout() -> void:
	damage_immunity = false
	

func shoot(direction:Vector2, speed2, damp=0, inherited_velocity=Vector2.ZERO):
	var a = projectile.instantiate()
	a.position = self.position
	a.linear_velocity = direction * speed2 + inherited_velocity
	a.linear_damp = damp
	#a.linear_velocity *= 1000
	#a.look_at(get_global_mouse_position())
	a.rotate(direction.angle())
	a.despawn_frame = projectile_lifetime * Engine.physics_ticks_per_second + Engine.get_physics_frames()
	a.attack_damage = attack_damage
	get_tree().get_current_scene().add_child(a)

func dash(direction:Vector2, impulse, duration, damp):
	self.apply_central_impulse(direction * impulse)
	self.rotate(direction.angle())
	

func _on_aim_timeout() -> void:
	aiming = true
	

func recalculate_stats():
	var cards = hud.card_container.get_children()
	var addends = {}
	var multipliers = {}
	var stats = ["health", "attack_speed", "attack_damage", "speed"]
	for stat in stats:
		addends[stat] = 0
		multipliers[stat] = 0
	
	for card in cards:
		#card.modifier_card
		for stat in card.modifier_card.modifiers:
			if get(stat.stat) == null:
				continue
			match stat.modifier_type:
				StatModifier.ModifierType.ADD:
					addends[stat.stat] += stat.modifier
				StatModifier.ModifierType.MULTIPLY:
					multipliers[stat.stat] += stat.modifier
					#set(stat.stat, get(stat.stat)
			#print(stat.stat)
			#print(get(stat.stat))
	
	for stat in stats:
		set(stat, get(stat) + addends[stat])
		set(stat, get(stat) * (1.0 + multipliers[stat]/100.0))
		print(stat)
		print(get(stat))
	
	
