extends Panel

@export var modifier_card:ModifierCard = null
@export var icon:Node = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Label.text = modifier_card.description

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
