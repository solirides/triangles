extends Control


func _ready() -> void:
	
	$Version.text = "version: " + str(ProjectSettings.get_setting("application/config/version"))
	$AnimationPlayer.play("triangles2")

func _on_start_pressed() -> void:
	GameManager.start_game()


func _on_quit_pressed() -> void:
	GameManager.quit_game()


func _on_options_pressed() -> void:
	pass # Replace with function body.
