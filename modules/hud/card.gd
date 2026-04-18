class_name GuiCard
extends Panel

@export var modifier_card:ModifierCard = null
@export var icon:Node = null
@export var expand_scale:float = 1.2

var focused = false
var picked = false
var dragged = false
var position_placeholder:Node
var previous_focus = false
@onready var stylebox:StyleBox = get_theme_stylebox("panel").duplicate()
var stylebox_2:StyleBox = get_theme_stylebox("panel").duplicate()
var pickup_lerp:float = 0.0
var pre_pickup_pos:Vector2 = Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	stylebox_2 = get_theme_stylebox("panel").duplicate()
	
	var p = ["border_width_left", "border_width_right", "border_width_top", "border_width_bottom"]
	var v = 2
	for i in p:
		#stylebox_2.set("border_width_top", v)
		stylebox_2.set(i, v)
	#stylebox_2.border_color = Color(1, 1, 1)
	
	$Label.text = modifier_card.description

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Rect2(Vector2(), size).has_point(get_local_mouse_position()):
		set_focus(true)
	else:
		set_focus(false)
	
	#if dragged:
		#global_position = lerp(pre_pickup_pos, get_global_mouse_position() - size/2.0, pickup_lerp)
		#print(pickup_lerp)

#func _on_mouse_entered() -> void:
	#print("mouse entered")
	#if position_placeholder != null:
		#if position_placeholder.focused == false:
			#set_focus(true)
	#else:
		#set_focus(true)
	##set_focus(true)
#
#func _on_mouse_exited() -> void:
	#print("mouse exited")
	#if position_placeholder != null:
		#if position_placeholder.focused == false:
			#set_focus(false)
	#else:
		#set_focus(false)
	##set_focus(false)

func set_focus(state:bool):
	var placeholder_focused = false
	if position_placeholder != null:
			if position_placeholder.focused:
				placeholder_focused = true
	if state == focused:
		return
	if state:
		focused = true
		z_index = 40
		await animate_hover(true)
	else:
		if placeholder_focused == false:
			focused = false
			z_index = 0
			if picked == false:
				await animate_hover(false)

func set_picked(state:bool):
	#print("card picked")
	if picked == state:
		#print("return")
		return
	#if pickup_tween:
		#pickup_tween.kill()
	if state:
		#pre_pickup_pos = global_position
		picked = true
		add_theme_stylebox_override("panel", stylebox_2)
		await animate_hover(true)
		#
		#pickup_tween = self.create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
		#pickup_tween.tween_property(self, "pickup_lerp", 1.0, 0.2)
		#print(pickup_tween)
	else:
		picked = false
		remove_theme_stylebox_override("panel")
		await animate_hover(false)
		#pickup_lerp = 0.0

var hover_tween:Tween
var pickup_tween:Tween
var position_tween:Tween
func animate_hover(state:bool):
	if hover_tween:
		hover_tween.kill()
	hover_tween = self.create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	if state:
		hover_tween.tween_property(self, "scale", Vector2(expand_scale, expand_scale), 0.15)
	else:
		hover_tween.tween_property(self, "scale", Vector2(1, 1), 0.1)
	await hover_tween.finished

func _on_gui_input(event: InputEvent) -> void:
	#if event.is_action_pressed("primary"):
		#set_picked(true)
	if event.is_action_released("primary"):
		if Rect2(Vector2(), size).has_point(get_local_mouse_position()):
			set_picked(!picked)

static func create_modifier_card(c:ModifierCard):
	var card_scene = preload("res://modules/hud/card.tscn")
	var card = card_scene.instantiate()
	card.modifier_card = c
	return card

#func has_mouse_focus(consider_placeholder:bool = true) -> bool:
	#if position_placeholder != null and consider_placeholder:
		#return focused || position_placeholder.focused
	#else:
		#return focused
	
