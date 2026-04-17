extends Panel

@export var modifier_card:ModifierCard = null
@export var icon:Node = null

var picked = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Label.text = modifier_card.description

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if picked:
		global_position = get_global_mouse_position() - size/2.0

func _on_mouse_entered() -> void:
	animate_hover(true)

func _on_mouse_exited() -> void:
	animate_hover(false)

var hover_tween:Tween
func animate_hover(state:bool):
	if hover_tween:
		hover_tween.kill()
	hover_tween = Tween.new()
	hover_tween = self.create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	var factor = 1.2
	if state:
		hover_tween.tween_property(self, "scale", Vector2(factor, factor), 0.3)
	else:
		hover_tween.tween_property(self, "scale", Vector2(1, 1), 0.2)
	

func _on_gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("primary"):
		picked = true
	if event.is_action_released("primary"):
		picked = false
