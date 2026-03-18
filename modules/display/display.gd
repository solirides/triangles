extends Node2D


func _ready() -> void:
	queue_redraw()

func _draw() -> void:
	draw_circle(Vector2(100,100), 40, Color(0.615, 0.979, 1.206, 1.0), false, 4)

func _process(delta: float) -> void:
	pass
