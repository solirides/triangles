class_name StatModifier
extends Resource

@export var stat:String
@export var modifier_value:float
@export var modifier_type:ModifierType

enum ModifierType {
	ADD,
	MULTIPLY
}

func _init(p_stat:String = "", p_modifier_value = 0, p_modifier_type = ModifierType.ADD) -> void:
	stat = p_stat
	modifier_value = p_modifier_value
	modifier_type = p_modifier_type
