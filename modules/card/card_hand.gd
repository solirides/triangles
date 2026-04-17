class_name CardHand
extends Resource

@export var modifier_cards:Array[ModifierCard] = []
@export var property_cards:Array[PropertyCard] = []

func _init(p_modifier_cards:Array[ModifierCard] = [], p_property_cards:Array[PropertyCard] = []) -> void:
	modifier_cards = p_modifier_cards
	property_cards = p_property_cards
