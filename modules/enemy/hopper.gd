#class_name Hopper
extends Enemy

@export_group("Enemy")
### seconds per hop
@export var hop_speed = 1.0
### delay between player tracking and hop in frames
@export var hop_delay:int = 4
@export var separation_weight = 0.5
@export var hop_impulse = 800


var hop_frame_speed:int = max(int(floor(hop_speed * Engine.physics_ticks_per_second)), 1)

var stored_target_position:Vector2 = Vector2.ZERO

func _init():
	enemy_type = ENEMY_TYPE.HOPPER

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.linear_damp = 4.0
	#print(hop_frame_speed)


func _physics_process(delta: float) -> void:
	#print("gfdhjgds")
	if target != null:
		#print("target")
		var physics_frame = Engine.get_physics_frames() - start_frame
		#print((physics_frame + hop_delay) % hop_frame_speed)
		if physics_frame % hop_frame_speed:
			stored_target_position = target.global_position
		elif (physics_frame + hop_delay) % hop_frame_speed:
			#print("hop")
			var vec = (stored_target_position - self.global_position).normalized()
			self.apply_central_impulse(vec * hop_impulse * mass)
			self.rotate(vec.angle())
			separation_accel()
			
	

func separation_accel():
	var view_range = 300
	for node in get_tree().get_nodes_in_group("enemy"):
		var vec = self.global_position - node.global_position
		if vec.length() < view_range:
			self.apply_central_impulse(vec.normalized() * (1 - vec.length()/view_range) * separation_weight * hop_impulse * mass)
	

func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	pass

func _on_body_entered(body: Node2D) -> void:
	_on_collision(body)
#
#func _on_area_2d_body_entered(body: Node2D) -> void:
	#_on_collision(body)
