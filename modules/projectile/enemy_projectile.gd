class_name EnemyProjectile
extends RigidBody2D

var despawn_frame = 0
var damage = 10

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
	if despawn_frame < Engine.get_physics_frames():
		self.queue_free()

static func calculate_despawn_frame(max_lifetime:float, speed:float, bounds:Vector2, damping:float) -> int:
	# estimate speed with damping
	var speed2 = speed
	if damping != 0:
		speed2 /= damping
	#var speed2 = speed / damping
	return min(max_lifetime, bounds.x / speed2, bounds.y / speed2) * Engine.physics_ticks_per_second + Engine.get_physics_frames();
	
