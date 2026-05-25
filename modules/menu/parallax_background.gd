extends Control

@onready var triangle:Node = $Polygon2D
var triangles = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var base_rot = triangle.rotation
	var base_scale = triangle.scale
	var base_color = triangle.color
	
	for i in range(30):
		var a = triangle.duplicate()
		a.scale = base_scale * (1.0 + i * 1.0)
		a.rotation = base_rot + i * 0.2
		var h  = fmod(base_color.h - (i * 0.02), 1)
		#print( fmod(base_color.h - (i * 0.02), 1))
		var s  = base_color.s * pow(0.95, i)
		var v  = base_color.v * pow(0.9, i)
		a.color = Color.from_hsv(h, s, v)
		add_child(a)
		move_child(a, 0)
		triangles.append(a)
		

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	for i in triangles.size():
		var offset = (get_global_mouse_position() - self.global_position) * 0.1 * pow(0.92, i)
		triangles[i].global_position = self.global_position + offset
