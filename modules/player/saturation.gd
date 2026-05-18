extends ColorRect


@export var player:Node

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#print(player.get_stat("health", "value"))
	#print(player.get_stat("health", "base_value"))
	var p = player.get_stat("health", "value") / float(player.get_stat("health", "base_value"))
	var saturation = clampf(p * 3.0, 0.2, 1.0)
	material.set("shader_parameter/saturation", saturation);
	
