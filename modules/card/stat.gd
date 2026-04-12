class_name Stat
extends Resource

@export var name:String
@export var base_value:float
@export var value:float
@export var description:String

func _init(p_name:String = "", p_base_value:float = 0, p_value:float = 0, p_description:String = "") -> void:
	name = p_name
	value = p_value
	base_value = p_base_value
	description = p_description
