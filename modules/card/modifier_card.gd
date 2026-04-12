class_name ModifierCard
extends Resource

@export var modifiers:Array[StatModifier]
@export var description:String

func _init(p_modifiers:Array[StatModifier] = [], p_description:String = "") -> void:
	modifiers = p_modifiers
	description = p_description
