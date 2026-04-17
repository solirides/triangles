class_name ModifierCard
extends GameCard

@export var modifiers:Array[StatModifier]


func _init(p_modifiers:Array[StatModifier] = []) -> void:
	modifiers = p_modifiers

static func generate_card(level:int):
	var card = ModifierCard.new()
	
	var stats = GameManager.player.stats
	var modifer_count = 2
	var stat_list = stats.keys()
	
	for i in modifer_count:
		#var modifier = StatModifier.new(stats.keys()[randi_range(0, stats.size() - 1)])
		var modifier = StatModifier.new(stat_list.pop_at(randi_range(0, stat_list.size() - 1)))
		var value = 3 + MathStuff.random_logarithmic(level + 1, 1.17, 0.64, 3.2)
		var value2 = -4 + MathStuff.random_logarithmic(level + 2, 1.24, 0.60, 3.1)
		#print(value)
		#print(MathStuff.random_logarithmic(level, 1.4, 0.24, 3.5))
		modifier.modifier_value = round(value2 * (i%2) + value * ((i+1)%2)) * (-1)**i
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
