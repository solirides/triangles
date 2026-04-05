extends Node2D


@export var player:Node = null
@onready var camera = $Camera2D
@onready var cursor = $Cursor
@export var follow_aim = 0.5
var velocity = Vector2.ZERO
var damping = 0.6

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var inst1 = $Cursor/Polygon2D
	for i in range(1,4):
		var inst2 = inst1.duplicate()
		inst2.rotate(PI/2 * i)
		$Cursor.add_child(inst2)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	self.position = lerp(self.position, player.position, 2.0 * delta)
	self.position = player.position
	# shift towards mouse
	camera.position = (get_global_mouse_position() - self.position) * 0.5 * follow_aim
	# (get_viewport_rect().size / 2)
	
	#velocity += (player.position - self.position) / 100.0
	#velocity.lerp(Vector2.ZERO,damping)
	#position += velocity
	cursor.global_position = get_global_mouse_position()

func shake(duration = 0.2, amplitude = 16, frequency = 20, level = 0):
	$CameraShake.shake(duration, amplitude, frequency, level)
	
