extends Node2D


@export var player:Node = null
@onready var camera = $Camera2D

var velocity = Vector2.ZERO
var damping = 0.6

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	self.position = lerp(self.position, player.position, 2.0 * delta)
	# shift towards mouse
	camera.position = (get_global_mouse_position() - self.position) * 0.1
	# (get_viewport_rect().size / 2)
	
	#velocity += (player.position - self.position) / 100.0
	#velocity.lerp(Vector2.ZERO,damping)
	#position += velocity
	
	
	
