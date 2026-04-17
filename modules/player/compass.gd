extends Node2D

var display = false
var target_position:Vector2 = Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.visible = false
	GameManager.update_compass.connect(_on_update_compass)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if target_position != null and display:
		#print("compass")
		#target_position = GameManager.compass_target_position
		var vec = (target_position - self.global_position).normalized()
		self.rotation = vec.angle()

func _on_update_compass(p_display:bool, target:Vector2):
	#print("update compass")
	self.visible = p_display
	display = p_display
	target_position = target
