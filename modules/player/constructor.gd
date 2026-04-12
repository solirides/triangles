extends Node2D

#@export var display:Node = null
var display:Node = null

#var velocity = Vector2.ZERO
enum CONSTRUCTION_STATE {
	NONE,
	SEGMENT_0,
	SEGMENT_1,
	SEGMENT_2,
	CIRCLE_0,
	CIRCLE_1,
	CIRCLE_2
}
var construction_state = CONSTRUCTION_STATE.SEGMENT_0
var current_shape = []
var shapes = []
var build_state = BUILD_STATE.NONE
enum BUILD_STATE {
	NONE,
	PARTIAL,
	COMPLETE
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	display = $"..".display

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if build_state == BUILD_STATE.PARTIAL:
		display.draw_shape_progress = true
		display.shape_progress(current_shape)
	else:
		display.draw_shape_progress = false


func construct():
	match construction_state:
		CONSTRUCTION_STATE.SEGMENT_0:
			current_shape.resize(3)
			current_shape[0] = "segment"
			current_shape[1] = self.global_position
			construction_state = CONSTRUCTION_STATE.SEGMENT_1
			build_state = BUILD_STATE.PARTIAL
		CONSTRUCTION_STATE.SEGMENT_1:
			current_shape[2] = self.global_position
			write_shape(current_shape)
			current_shape = []
			construction_state = CONSTRUCTION_STATE.SEGMENT_0
			BUILD_STATE.COMPLETE
		CONSTRUCTION_STATE.SEGMENT_2:
			pass
		_:
			pass

func write_shape(data:Array):
	display.shapes.append(data)
