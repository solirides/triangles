extends Control

@export var card_container:Node = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameManager.player_node_ready.connect(_on_player_ready)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var text = "FPS: " + str(Engine.get_frames_per_second())
	var label = $VBoxContainer/Label
	label.text = text
	
	var progress_bar = $VBoxContainer/ProgressBar
	progress_bar.value = GameManager.player.get_stat("health")
	progress_bar.max_value = GameManager.player.base_health
	

func _on_player_ready():
	pass
