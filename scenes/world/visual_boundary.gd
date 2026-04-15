extends Node2D


var shapes:Array = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _draw() -> void:
	for shape in shapes:
		#if shape.disabled == true:
			#continue
		#else:
		var color = Color(1,1,1,1)
		var width = 2
		draw_polyline(shape.polygon, color, width)
		draw_line(shape.polygon[0], shape.polygon[-1], color, width)

func _on_world_boundary_boundary_changed(shapes:Array) -> void:
	self.shapes = shapes
	queue_redraw()
