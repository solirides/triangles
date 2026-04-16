extends Node2D


@export var player:Node = null
@onready var camera = $Camera2D
@onready var cursor = $Cursor
@export var follow_aim = 0.5
@export var lerp_speed = 50
@export var offset:Vector2 = Vector2(0,0)
var velocity = Vector2.ZERO
var damping = 0.6


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	self.global_position = lerp(self.global_position, player.global_position - offset, lerp_speed * delta)
	#self.position = player.position - offset
	# shift towards mouse
	camera.position = (get_global_mouse_position() - self.global_position) * 0.5 * follow_aim
	# (get_viewport_rect().size / 2)
	
	#velocity += (player.position - self.position) / 100.0
	#velocity.lerp(Vector2.ZERO,damping)
	#position += velocity

func shake(duration = 0.2, amplitude = 16, frequency = 20, level = 0):
	$CameraShake.shake(duration, amplitude, frequency, level)
	
