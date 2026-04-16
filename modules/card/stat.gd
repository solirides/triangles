class_name Stat
extends Resource

@export var name:String
@export var base_value:float
@export var modified_value:float = base_value
@export var value:float = base_value
@export var description:String
@export var max_value:float = INF
@export var min_value:float = -INF

func _init(p_name:String = "", p_description:String = "", p_base_value:float = 0, p_min_value:float = -INF, p_max_value:float = INF, p_modified_value:float = p_base_value, p_value:float = p_base_value) -> void:
	name = p_name
	value = p_value
	base_value = p_base_value
	modified_value = p_modified_value
	description = p_description
	max_value = p_max_value
	min_value = p_min_value
