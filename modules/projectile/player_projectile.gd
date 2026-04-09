extends RigidBody2D

var despawn_frame = 0
var attack_damage = 10

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
	if despawn_frame < Engine.get_physics_frames() or linear_velocity.length() < 6:
		self.queue_free()
