extends Node2D


@export var player:Node = null

var shapes = []
@export var color = Color(1,0.5,0.5,1)
var width = 4
var draw_shape_progress = false
var partial_shape = []

func init():
	GameManager.display_node = self

func _ready() -> void:
	queue_redraw()

func _draw() -> void:
	for shape in shapes:
		match shape[0]:
			"segment":
				draw_line(shape[1], shape[2], color, width)
			"circle":
				pass
			_:
				pass
	if len(partial_shape) >= 1 and draw_shape_progress == true:
		match partial_shape[0]:
			"segment":
				draw_line(partial_shape[1], player.global_position, color, width)
			_:
				pass
				
	draw_circle(Vector2(0,0), 24, Color(0.615, 0.979, 1.206, 1.0), false, 4)

func _process(delta: float) -> void:
	queue_redraw()

func shape_progress(data:Array):
	partial_shape = data.duplicate()
