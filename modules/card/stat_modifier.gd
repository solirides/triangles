class_name StatModifier
extends Resource

@export var stat:String
@export var modifier:float
@export var modifier_type:ModifierType

enum ModifierType {
	ADD,
	MULTIPLY
}

func _init(p_stat, p_modifier, p_modifier_type) -> void:
	stat = p_stat
	modifier = p_modifier
	modifier_type = p_modifier_type
