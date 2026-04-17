extends Node

@export var autostart = false
@onready var global_audio = $GlobalAudio

var player:Node = null
var in_world = false
var game_stage:GAME_STAGE = GAME_STAGE.NONE
var display_node
var approximate_bounds = Rect2(-768.0,-768.0,2*768.0,2*768.0)
var player_level = 1
#var compass_target_position:Vector2
#var enemy_nodes:Array[Node] = []

var card_hands:Array[CardHand] = []

var ready_state_bool = false

var ready_state = {
	"player": false,
	"world": false
}

enum GAME_STAGE {
	NONE,
	MENU,
	INITIATION,
	ROOM_MAP,
	COMBAT,
	IDK
}

signal enemy_death()
signal player_node_ready()
signal update_compass(display:bool, target:Vector2)
signal all_initial_nodes_ready()
signal card_hand_updated()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	process_mode = ProcessMode.PROCESS_MODE_ALWAYS
	get_tree().set_auto_accept_quit(false)
	get_window().grab_focus()
	#Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED_HIDDEN)
	if autostart:
		advance_game_stage(GAME_STAGE.COMBAT)

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
	advance_game_stage(GAME_STAGE.INITIATION)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		if Input.mouse_mode != Input.MOUSE_MODE_VISIBLE:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		else:
			if in_world:
				Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED_HIDDEN)
			else:
				Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)

func set_in_world(state:bool):
	in_world = state
	if state == true:
		pass
	

func advance_game_stage(stage:GAME_STAGE):
	get_tree().paused = false
	game_stage = stage
	match game_stage:
		GAME_STAGE.NONE:
			get_tree().change_scene_to_file("res://scenes/world/initiation.tscn")
		GAME_STAGE.MENU:
			get_tree().change_scene_to_file("res://modules/menu/main_menu.tscn")
		GAME_STAGE.INITIATION:
			get_tree().change_scene_to_file("res://scenes/world/initiation.tscn")
		GAME_STAGE.ROOM_MAP:
			get_tree().change_scene_to_file("res://scenes/world/world.tscn")
			#get_tree().change_scene_to_file("res://scenes/room_map/room_map.tscn")
		GAME_STAGE.COMBAT:
			get_tree().change_scene_to_file("res://scenes/world/world.tscn")
		_:
			print("???")
	for k in ready_state.keys():
		ready_state[k] = false
	ready_state_bool = false

func quit_game():
	get_tree().quit()

func _notification(what):
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		print("window quit requested")
		quit_game()

func _on_enemy_death():
	enemy_death.emit()

func restart():
	advance_game_stage(GAME_STAGE.INITIATION)

func main_menu():
	advance_game_stage(GAME_STAGE.MENU)

func game_over():
	get_tree().paused = true
