extends Panel

var card:Node
var focused = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#pass
	set_focus(true)

#func _on_mouse_entered() -> void:
	#set_focus(true)
	#card._on_mouse_exited()
#
#func _on_mouse_exited() -> void:
	#set_focus(false)
	#card._on_mouse_exited()

func set_focus(state:bool):
	#if state or Rect2(Vector2(), size).has_point(get_local_mouse_position()):
	if Rect2(Vector2(), size).has_point(get_local_mouse_position()):
		focused = true
		#z index does not affect input processing
		#z_index = 15
	else:
		focused = false
		#z_index = 5
	#print("placeholder focus: " + str(focused))
