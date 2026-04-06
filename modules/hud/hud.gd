extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var text = "FPS: " + str(Engine.get_frames_per_second())
	var label = $VBoxContainer/Label
	label.text = text
	
	var progress_bar = $VBoxContainer/ProgressBar
	progress_bar.value = GameManager.player.health
	progress_bar.max_value = GameManager.player.base_health
	
