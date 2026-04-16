class_name ModifierCard
extends Resource

@export var modifiers:Array[StatModifier]
@export_multiline var description:String

func _init(p_modifiers:Array[StatModifier] = [], p_description:String = "") -> void:
	modifiers = p_modifiers
	description = p_description

static func generate_card(level:int):
	var card = ModifierCard.new()
	
	var modifer_count = 2
	for i in modifer_count:
		var stats = GameManager.player.stats
		var modifier = StatModifier.new(stats.keys()[randi_range(0, stats.size() - 1)])
		modifier.modifier_value = round(randf_range(0,100))
		modifier.modifier_type = StatModifier.ModifierType.MULTIPLY
		card.modifiers.append(modifier)
	
	card.description = generate_description(card)
	
	return card

static func generate_description(card:ModifierCard):
	var a = ""
	for modifier in card.modifiers:
		var sign = ""
		if modifier.modifier_value >= 0:
			sign = "+"
		var p = ""
		if modifier.modifier_type == StatModifier.ModifierType.MULTIPLY:
			p = "%"
		a += sign + str(modifier.modifier_value) + p + " " + modifier.stat + "\n"
	return a
