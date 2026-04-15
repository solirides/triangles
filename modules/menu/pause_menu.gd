extends Control

@onready var game_over_screen = $GameOver
@onready var game_over_shader = $GameOver/Posterize
@onready var game_over_label = $GameOver/Label
@onready var animation_player = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	#game_over()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func game_over():
	game_over_screen.visible = true
	#game_over_shader.material.set_shader_parameter("luminosity_offset", 0.7)
	#game_over_screen.create_tween().tween_property(game_over_screen, "color", Color(1,1,1,0), 0.5)
	game_over_label.label_settings.font_color = Color(1,1,1,0)
	var tween = create_tween().set_parallel()
	tween.tween_method(set_luminosity, -1.0, 1.0, 2.0)
	tween.tween_method(set_randomness, 0.2, 0.8, 2.0)
	tween.set_parallel(false)
	tween.tween_property(game_over_label.label_settings, "font_color", Color(1,1,1,1), 0.3)
	tween.tween_callback(animation_player.play.bind("you_died"))
	# this line looks so terrible I hate it
	tween.tween_callback($GameOver/VBoxContainer.set.bind("visible", true))

func set_luminosity(value):
	game_over_shader.material.set_shader_parameter("luminosity_offset", value)

func set_randomness(value):
	game_over_shader.material.set_shader_parameter("randomness", value)

func _on_main_menu_pressed() -> void:
	GameManager.main_menu()

func _on_restart_pressed() -> void:
	GameManager.restart()
