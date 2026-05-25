extends Node

@export var autostart = false
@onready var global_audio = $GlobalAudio

@export_group("Movement")
@export var base_speed = 320
#@export var aim_speed_multiplier = 0.6
@export_category("Attack")
@export var base_health:int = 50
@export var base_attack_damage:int = 10
@export var base_shot_count:int = 1
@export var base_projectile_speed:float = 2000
@export var base_projectile_spread:float = 0.1
@export var base_damage_immunity_time:float = 0.3
@export var base_attack_speed:float = 2

var player:Node = null
var world_node:Node = null
var in_world = false
var game_stage:GameStage = GameStage.NONE
var display_node
var approximate_bounds = Rect2(-768.0,-768.0,2*768.0,2*768.0)
var player_level = 1
var active_card_hand_i = 0
@onready var player_stats = {
	"speed": Stat.new("speed", "", base_speed, 10),
	"health": Stat.new("health", "", base_health, 1),
	"attack_speed": Stat.new("attack_speed", "", base_attack_speed, 0.1),
	"attack_damage": Stat.new("attack_damage", "", base_attack_damage, 1),
	"shot_count": Stat.new("shot_count", "", base_shot_count, 1),
	"projectile_speed": Stat.new("projectile_speed", "", base_projectile_speed, 1),
	"projectile_spread": Stat.new("projectile_spread", "", base_projectile_spread),
	"damage_immunity_time": Stat.new("damage_immunity_time", "", base_damage_immunity_time)
}

#var compass_target_position:Vector2
#var enemy_nodes:Array[Node] = []

# same index for weapons and card hands
var weapons:Array = []
var card_hands:Array[CardHand] = []

var ready_state_bool = false

var ready_state = {
	"player": false,
	"world": false
}

enum GameStage {
	NONE,
	MENU,
	INITIATION,
	ROOM_MAP,
	COMBAT,
	CARD_UPGRADE,
	IDK
}

var game_stats = {
	"kills": 0,
	"damage": 0,
}

signal enemy_death()
signal player_node_ready()
signal update_compass(display:bool, target:Vector2)
signal all_initial_nodes_ready()
signal card_hand_updated()
signal weapons_changed()
signal active_hand_changed(hand_i:int)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	process_mode = ProcessMode.PROCESS_MODE_ALWAYS
	get_tree().set_auto_accept_quit(false)
	get_window().grab_focus()
	#Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED_HIDDEN)
	if autostart:
		advance_game_stage(GameStage.COMBAT)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
	if ready_state_bool == false:
		var ready = true
		for k in ready_state.keys():
			if ready_state[k] != true:
				ready = false
				break
		if ready:
			print("all initial nodes ready")
			all_initial_nodes_ready.emit()
			ready_state_bool = true

func start_game():
	#print("START")
	advance_game_stage(GameStage.INITIATION)

func _input(event: InputEvent) -> void:
	#if event.is_action_pressed("ui_cancel"):
		#if Input.mouse_mode != Input.MOUSE_MODE_VISIBLE:
			#Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		#else:
			#if in_world:
				#Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED_HIDDEN)
			#else:
				#Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)
	if Input.is_action_just_pressed("pause"):
		var state = !get_tree().paused
		if ready_state["player"]:
			toggle_pause(state)
			player.menu.toggle_pause_menu(state)
		#toggle_pause_menu(false)

func toggle_pause(state:bool):
	get_tree().paused = state

func set_in_world(state:bool):
	in_world = state
	if state == true:
		pass
	

func advance_game_stage(stage:GameStage):
	get_tree().paused = false
	game_stage = stage
	var scene = ""
	match game_stage:
		GameStage.NONE:
			scene = "res://scenes/world/initiation.tscn"
			#get_tree().change_scene_to_file("res://scenes/world/initiation.tscn")
		GameStage.MENU:
			scene = "res://modules/menu/main_menu.tscn"
			#get_tree().change_scene_to_file("res://modules/menu/main_menu.tscn")
		GameStage.INITIATION:
			scene = "res://scenes/world/initiation.tscn"
			#get_tree().change_scene_to_file("res://scenes/world/initiation.tscn")
		GameStage.ROOM_MAP:
			scene = "res://scenes/world/world.tscn"
			#get_tree().change_scene_to_file("res://scenes/world/world.tscn")
			#get_tree().change_scene_to_file("res://scenes/room_map/room_map.tscn")
		GameStage.COMBAT:
			scene = "res://scenes/world/world.tscn"
			#get_tree().change_scene_to_file("res://scenes/world/world.tscn")
		GameStage.CARD_UPGRADE:
			scene = "res://modules/menu/card_selection_menu.tscn"
			
		_:
			print("???")
	for k in ready_state.keys():
		ready_state[k] = false
	ready_state_bool = false
	
	start_scene_change(scene)
	#get_tree().change_scene_to_file.bind(scene).call_deferred()

func start_scene_change(scene:String):
	ResourceLoader.load_threaded_request(scene)
	$Transition.await_scene_change(scene)
	
	

func initiate_card_hand():
	print("generate cards")
	card_hands.clear()
	var h = CardHand.new()
	for i in range(2):
		var c = ModifierCard.generate_card(1)
		h.modifier_cards.append(c)
	card_hands.append(h)
	
	var h2 = CardHand.new()
	card_hands.append(h2)
	
	weapons.append(Player.Weapon.SHOTGUN)
	weapons.append(Player.Weapon.SWORD)
	
	card_hand_updated.emit()
	

func swap_active_hand(index:int = -1):
	var hand_i = (active_card_hand_i + 1) % card_hands.size()
	if index >= 0:
		hand_i = index
	active_card_hand_i = hand_i
	
	active_hand_changed.emit(hand_i)
	
	global_audio.play("card")
	print("swapped to hand " + str(hand_i))

func quit_game():
	get_tree().quit()

func _notification(what):
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		print("window quit requested")
		quit_game()

func _on_enemy_death():
	game_stats["kills"] += 1
	enemy_death.emit()

func restart():
	player_level = 1
	active_card_hand_i = 0
	weapons = []
	card_hands = []
	for k in game_stats:
		game_stats[k] = 0
	advance_game_stage(GameStage.INITIATION)

func main_menu():
	advance_game_stage(GameStage.MENU)

func game_over():
	get_tree().paused = true
