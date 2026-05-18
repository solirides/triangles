class_name GameCard
extends Resource

@export_multiline var description:String = ""
var icon

func _init(p_description:String = "", p_icon:String = "") -> void:
	description = p_description
	icon = p_icon
