class_name GameCard
extends Resource

@export_multiline var description:String = ""

func _init(p_description:String = "") -> void:
	description = p_description
