extends Node2D


@export var player:Node
@export var start_angle = -PI/2.0
var reload_progress:float = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	queue_redraw()

func _draw() -> void:
	
	#var reload_progress = player.attack_cooldown_timer.time_left
	
	# position is relative to player
	draw_arc(Vector2(0,0), 30, start_angle, start_angle+2*PI*reload_progress, 40, Color(1,1,1,0.5), 3, true)
	#draw_circle(Vector2(0,0),100,Color(1,1,1,1),true)
	
