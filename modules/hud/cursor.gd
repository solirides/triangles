extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var inst1 = $Polygon2D
	for i in range(1,4):
		var inst2 = inst1.duplicate()
		inst2.rotate(PI/2 * i)
		add_child(inst2)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	self.global_position = get_global_mouse_position()
