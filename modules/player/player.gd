class_name Player
extends RigidBody2D

@export_group("Movement")
@export var const_movement_velocity = true
@export var accel = 1
@export var movement_damping = 0.1
@export var decel = 0.3
#@export var base_speed = 320
@export var drag = 0.1
#@export var aim_speed_multiplier = 0.6
@export_category("Attack")
#@export var base_health:int = 100
#@export var base_attack_damage:int = 10
#@export var base_shot_count:int = 3
#@export var base_projectile_speed:float = 1000
#@export var base_projectile_spread:float = 0.1
@export var projectile_lifetime:float = 5
#@export var base_damage_immunity_time:float = 0.8
#@export var base_attack_speed:float = 2

@export_group("Nodes")
@export var display:Node = null
@export var pivot:Node = null
@onready var immunity_timer:Timer = $Immunity
@onready var attack_cooldown_timer:Timer = $Attack
#@onready var raycast:ShapeCast2D = $Pivot/ShapeCast2D
#@onready var laser_polygon:Polygon2D = $Pivot/Laser
@export var camera_controller:Node = null
@export var hud:Node = null
@export var menu:Node = null
@export var compass:Node = null

@export var modifier_cards:Array[ModifierCard] = []

#var speed = base_speed
#var health = base_health
#var attack_speed = base_attack_speed
#var attack_damage = base_attack_damage

# passed by REFERENCE
@onready var stats = GameManager.player_stats

var projectile = preload("res://modules/projectile/player_projectile.tscn")
var turret = preload("res://modules/enemy/turret.tscn")
var hopper = preload("res://modules/enemy/hopper.tscn")
#var laser_polygon = preload("res://modules/projectile/laser.tscn")

# temporary immunity to enemy attacks
var damage_immunity = false
var movement_input = true
var aiming = false
#var active_card_hand_i = 0

enum Weapon {
	SHOTGUN,
	BLASTER,
	LASER,
	SWORD
}

const WEAPON_NAMES = {
	Weapon.SHOTGUN : "Shotgun",
	Weapon.BLASTER : "Blaster",
	Weapon.LASER : "Laser",
	Weapon.SWORD : "Sword"
}

@onready var weapon_nodes:Dictionary = {
	Weapon.SHOTGUN : $Weapons/Shotgun,
	Weapon.BLASTER : $Weapons/Blaster,
	Weapon.LASER : $Weapons/Laser,
	Weapon.SWORD : $Weapons/Sword
}

@onready var constructor = $Constructor

func _ready() -> void:
	GameManager.player = self
	GameManager.all_initial_nodes_ready.connect(_on_all_initial_nodes_ready)
	
	
	#laser_polygon.scale.y = 0
	GameManager.player_node_ready.emit()
	
	GameManager.ready_state["player"] = true
	
	GameManager.card_hand_updated.connect(_on_card_hand_updated)
	GameManager.card_hand_updated.emit()
	#GameManager.initiate_card_hand()
	
	# set to max health
	set_stat("health", get_stat("health", "modified_value"))
	
	get_tree().create_timer(1).timeout.connect(func(): view_status(true))
	get_tree().create_timer(3).timeout.connect(func(): view_status(false))
	

func _on_all_initial_nodes_ready():
	recalculate_stats()
	swap_active_hand(0)

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
			state.linear_velocity = vec * get_stat("speed")
		else:
			state.apply_central_force(vec * mass * get_stat("speed"))
			#state.apply_central_force(mass * (vec * speed / movement_damping - linear_velocity * movement_damping))
			#state.linear_velocity = state.linear_velocity.lerp(Vector2.ZERO, movement_damping)
			# a = F/m = (f-d)/m = (f-(v*u))/m
			# a = 0 ==> f=(v*u)
			# v = f/u
			
	#integrate_forces()

var aim_tween:Tween

func _physics_process(delta: float) -> void:
	
	if Input.is_action_just_pressed("status"):
		view_status(true)
	elif Input.is_action_just_released("status"):
		view_status(false)
	
	
	if Input.is_action_just_pressed("special1"):
		# set aiming = true after delay
		$Aim.start(0.2)
		#$Aim.timeout.connect(func(): aiming = true)
		#speed = base_speed * aim_speed_multiplier
		# animate camera zoom
		if aim_tween:
			aim_tween.kill()
		aim_tween = create_tween()
		aim_tween.tween_property(camera_controller.camera, "zoom", Vector2(1.3,1.3), 0.3).set_trans(Tween.TRANS_SINE)
		#camera.camera.zoom = 
	if Input.is_action_just_released("special1"):
		$Aim.stop()
		aiming = false
		#speed = base_speed
		# animate camera zoom
		#var tween = get_tree().create_tween()
		if aim_tween:
			aim_tween.kill()
		aim_tween = create_tween()
		aim_tween.tween_property(camera_controller.camera, "zoom", Vector2(1,1), 0.12).set_trans(Tween.TRANS_SINE)
		#camera.camera.zoom = Vector2(1,1)
	
	#if Input.is_action_pressed("special2"):
		#if attack_cooldown_timer.time_left == 0:
			##attack_cooldown_timer.start(1 / get_stat("attack_speed"))
			#$Weapons/Blaster.attack()
		
	if Input.is_action_pressed("primary"):
		if attack_cooldown_timer.time_left == 0:
			#attack_cooldown_timer.start(1 / get_stat("attack_speed"))
			weapon_nodes[GameManager.weapons[GameManager.active_card_hand_i]].attack()
			#$Weapons/Shotgun.attack()
	
	if Input.is_action_just_pressed("secondary"):
		if attack_cooldown_timer.time_left == 0:
			#attack_cooldown_timer.start(1 / get_stat("attack_speed"))
			#$Weapons/Laser.attack()
			swap_active_hand()
	
	#if Input.is_action_just_pressed("construct"):
		#$Weapons/Sword.attack()
		##🔥🔥🔥
		#constructor.construct()
	#
	#if Input.is_action_just_pressed("spawn"):
		#var a = turret.instantiate()
		#a.position = get_global_mouse_position()
		#get_tree().get_current_scene().add_child(a)
	#if Input.is_action_just_pressed("spawn2"):
		#var a = hopper.instantiate()
		#a.target = GameManager.player
		#a.position = get_global_mouse_position()
		#get_tree().get_current_scene().add_child(a)

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

func damage(amount:int) -> bool:
	if damage_immunity == true:
		return false
	else:
		GameManager.global_audio.play("player_hit")
		camera_controller.shake(0.24, 16, 20, 1)
		#print("player hit!")
		start_damage_immunity(get_stat("damage_immunity_time"))
		set_stat("health", get_stat("health")-amount)
		print("player health:" + str(get_stat("health")))
		if get_stat("health") <= 0:
			game_over()
		return true

func game_over():
	GameManager.game_over()
	menu.game_over()

func view_status(state:bool):
	#slow_time_scale(state)
	hud.show_card_hand(state)
	hud.animate_background_tint(state)

var time_scale_tween:Tween
func slow_time_scale(state:bool):
	if time_scale_tween:
		time_scale_tween.kill()
	time_scale_tween = Tween.new()
	time_scale_tween.set_pause_mode(Tween.TweenPauseMode.TWEEN_PAUSE_PROCESS)
	time_scale_tween = self.create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	var factor = 0.3
	if state:
		#view_status_tween.tween_property(Engine, "physics_ticks_per_second", factor, 0.3)
		time_scale_tween.tween_property(Engine, "time_scale", factor, 0.3)
	else:
		#view_status_tween.tween_property(Engine, "physics_ticks_per_second", 1.0, 0.15)
		time_scale_tween.tween_property(Engine, "time_scale", 1.0, 0.15)
	

func _on_invincibility_timeout() -> void:
	damage_immunity = false
	

func shoot(direction:Vector2, speed2, damp=0, inherited_velocity=Vector2.ZERO, damage:int=get_stat("attack_damage")):
	var a = projectile.instantiate()
	a.position = self.position
	a.linear_velocity = direction * speed2 + inherited_velocity
	a.linear_damp = damp
	#a.linear_velocity *= 1000
	#a.look_at(get_global_mouse_position())
	a.rotate(direction.angle())
	a.despawn_frame = projectile_lifetime * Engine.physics_ticks_per_second + Engine.get_physics_frames()
	a.attack_damage = damage
	get_tree().get_current_scene().add_child(a)

func dash(direction:Vector2, impulse, duration, damp):
	self.apply_central_impulse(direction * impulse)
	self.rotate(direction.angle())
	

func _on_aim_timeout() -> void:
	aiming = true
	

func recalculate_stats():
	if GameManager.card_hands.size() <= GameManager.active_card_hand_i:
		return
	
	var cards = hud.card_container.get_children()
	var addends = {}
	var multipliers = {}
	#var stats = ["health", "attack_speed", "attack_damage", "speed"]
	for stat in self.stats.keys():
		addends[stat] = 0
		multipliers[stat] = 0
	
	for card in GameManager.card_hands[GameManager.active_card_hand_i].modifier_cards:
		for modifier in card.modifiers:
			#print(modifier)
			if modifier.stat not in self.stats.keys():
				continue
			match modifier.modifier_type:
				StatModifier.ModifierType.ADD:
					addends[modifier.stat] += modifier.modifier_value
				StatModifier.ModifierType.MULTIPLY:
					multipliers[modifier.stat] += modifier.modifier_value
					#set(stat.stat, get(stat.stat)
			#print(stat.stat)
			#print(get(stat.stat))
	
	for stat_name in self.stats.keys():
		var stat = self.stats[stat_name]
		var old_modified_value:float = stat.modified_value
		stat.modified_value = stat.base_value
		stat.modified_value += addends[stat_name]
		stat.modified_value *= (1.0 + multipliers[stat_name]/100.0)
		stat.modified_value = clampf(stat.modified_value, stat.min_value, stat.max_value)
		if stat_name == "health":
			stat.value = stat.modified_value * (stat.value / old_modified_value)
		else:
			stat.value = stat.modified_value
		#set(stat_name, get(stat_name) + addends[stat_name])
		#set(stat_name, get(stat_name) * (1.0 + multipliers[stat_name]/100.0))
		print_rich("[color=blue][b]" + stat_name)
		print("base stat_name:" + str(stat.base_value))
		print("modified stat_name: " + str(stat.modified_value))
		print("actual value: " + str(stat.value))
	
	attack_cooldown_timer.wait_time = 1 / get_stat("attack_speed")
	immunity_timer.wait_time = get_stat("damage_immunity_time")

func get_stat(stat:String, property:String="value"):
	return self.stats[stat].get(property)

func set_stat(stat:String, value:float):
	self.stats[stat].value = value

func _on_card_hand_updated():
	recalculate_stats()

func start_attack_cooldown(duration:float):
	$EffectCanvas.reload_progress = 0
	var tween = create_tween()
	# animate to 1.05 so the circle can be visually complete
	tween.tween_property($EffectCanvas, "reload_progress", 1.05, duration)
	tween.tween_property($EffectCanvas, "reload_progress", 0, 0)
	attack_cooldown_timer.start(duration)

var immunity_tween
func start_damage_immunity(duration:float, animate:bool=true):
	damage_immunity = true
	immunity_timer.start(duration)
	
	if animate:
		if immunity_tween != null:
			immunity_tween.kill()
		immunity_tween = create_tween().set_trans(Tween.TRANS_SINE)
		var t = 0
		while t < get_stat("damage_immunity_time"):
			immunity_tween.tween_property(self, "modulate", Color(1,1,1,0), 0.04)
			immunity_tween.tween_property(self, "modulate", Color.WHITE, 0.04)
			t += 0.08

func swap_active_hand(hand_i:int = -1):
	GameManager.swap_active_hand(hand_i)
	
	recalculate_stats()
	# make only current weapon visible
	for n in weapon_nodes.values():
		n.visible = false
	weapon_nodes[GameManager.weapons[GameManager.active_card_hand_i]].visible = true
	#print(weapon_nodes[GameManager.weapons[GameManager.active_card_hand_i]])
	
