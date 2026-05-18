extends Node2D



@export var player:Node

@onready var raycast:ShapeCast2D = $"../../Pivot/ShapeCast2D"
var laser_polygon = preload("res://modules/projectile/laser.tscn")

@export var damage:float = 3
@export var attack_speed:float = 0.2
#@export var projectile_speed:float = 1
#@export var projectile_spread:float = 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func attack():
	var cooldown_duration = 1.0 / (player.get_stat("attack_speed")*attack_speed)
	player.start_attack_cooldown(cooldown_duration)
	
	raycast.force_shapecast_update()
	var hit = false
	while raycast.is_colliding():
		for i in raycast.get_collision_count():
			var collider = raycast.get_collider(i)
			raycast.add_exception(collider)
			
			if collider.is_in_group("enemy_projectile"):
				collider.queue_free()
				hit = true
			elif collider.is_in_group("enemy"):
				collider.damage(50)
				hit = true
		raycast.force_shapecast_update()
	raycast.clear_exceptions()
	if hit:
		player.camera_controller.shake(0.16, 14, 20, 0)
	
	var a = laser_polygon.instantiate()
	a.scale.y = 0
	a.global_position = player.pivot.global_position + Vector2(20,0).rotated(player.pivot.global_rotation)
	a.global_rotation = player.pivot.global_rotation
	get_tree().get_current_scene().add_child(a)
	
	var tween = self.create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(a, "scale", Vector2(1,1), 0.03)
	tween.tween_property(a, "scale", Vector2(1,1), 0.26)
	tween.tween_property(a, "modulate", Color(1,1,1,0), 0.03)
	tween.tween_property(a, "modulate", Color(1,1,1,1), 0.03)
	tween.tween_property(a, "scale", Vector2(1,0), 0.04)
	tween.tween_callback(a.queue_free)
