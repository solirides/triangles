extends Node


var player:Node = null
var in_world = false
var game_stage:GAME_STAGE = GAME_STAGE.NONE
var autostart = true
var display_node
#var enemy_nodes:Array[Node] = []

enum GAME_STAGE {
	NONE,
	INITIATION,
	ROOM_MAP,
	COMBAT,
	IDK
}

signal enemy_death()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_tree().set_auto_accept_quit(false)
	get_window().grab_focus()
	#Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED_HIDDEN)
	if autostart:
		advance_game_stage(GAME_STAGE.COMBAT)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func start_game():
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
	game_stage = stage
	match game_stage:
		GAME_STAGE.NONE:
			get_tree().change_scene_to_file("res://scenes/world/initiation.tscn")
		GAME_STAGE.INITIATION:
			get_tree().change_scene_to_file("res://scenes/world/initiation.tscn")
		GAME_STAGE.ROOM_MAP:
			get_tree().change_scene_to_file("res://scenes/world/world.tscn")
			#get_tree().change_scene_to_file("res://scenes/room_map/room_map.tscn")
		GAME_STAGE.COMBAT:
			get_tree().change_scene_to_file("res://scenes/world/world.tscn")
		_:
			print("???")

func quit_game():
	get_tree().quit()

func _notification(what):
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		print("window quit requested")
		quit_game()

func _on_enemy_death():
	enemy_death.emit()
