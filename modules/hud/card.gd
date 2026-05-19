class_name GuiCard
extends Panel

@export var modifier_card:ModifierCard = null
@export var icon:Node = null
@export var expand_scale:float = 1.2

var empty = false

var focused = false
var picked = false
var dragged = false

var position_placeholder:Node
var previous_focus = false
@onready var stylebox:StyleBox = get_theme_stylebox("panel").duplicate()
var stylebox_2:StyleBox = get_theme_stylebox("panel").duplicate()
var pickup_lerp:float = 0.0
var pre_pickup_pos:Vector2 = Vector2.ZERO

var icons = {
	"speed": preload("res://assets/textures/icons/movement_speed.png"),
	"health": preload("res://assets/textures/icons/max_health.png"),
	"attack_speed": preload("res://assets/textures/icons/attack_speed.png"),
	"attack_damage": preload("res://assets/textures/icons/skull.png"),
	"shot_count": preload("res://assets/textures/icons/shot_count.png"),
	"projectile_speed": preload("res://assets/textures/icons/special_time.png"),
	"projectile_spread": preload("res://assets/textures/icons/spread.png"),
	"damage_immunity_time": preload("res://assets/textures/icons/special_time.png")
	
}

var empty_stylebox = preload("res://assets/themes/empty_card_stylebox.tres")
var normal_stylebox

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if empty:
		add_theme_stylebox_override("panel", empty_stylebox)
		#set_stylebox(empty_stylebox)
		
	normal_stylebox = get_theme_stylebox("panel")
	
	stylebox_2 = get_theme_stylebox("panel").duplicate()
	
	var p = ["border_width_left", "border_width_right", "border_width_top", "border_width_bottom"]
	var v = 2
	for i in p:
		#stylebox_2.set("border_width_top", v)
		stylebox_2.set(i, v)
	#stylebox_2.border_color = Color(1, 1, 1)
	
	if modifier_card != null:
		$Label.text = modifier_card.description
		var icon
		if icons.keys().has(modifier_card.icon):
			icon = icons[modifier_card.icon]
		$Icon.texture = icon
	else:
		$Label.text = ""
		$Icon.texture = null

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

func set_focus(state:bool, instant:bool = false):
	var placeholder_focused = false
	if position_placeholder != null:
			if position_placeholder.focused:
				placeholder_focused = true
	if state == focused:
		return
	if state:
		focused = true
		z_index = 40
		await animate_hover(true, instant)
	else:
		if placeholder_focused == false:
			focused = false
			z_index = 0
			if picked == false:
				await animate_hover(false, instant)


func set_picked(state:bool, instant:bool = false):
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
		await animate_hover(true, instant)
		#
		#pickup_tween = self.create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
		#pickup_tween.tween_property(self, "pickup_lerp", 1.0, 0.2)
		#print(pickup_tween)
	else:
		picked = false
		if empty:
			add_theme_stylebox_override("panel", empty_stylebox)
		else:
			remove_theme_stylebox_override("panel")
		await animate_hover(false, instant)
		#pickup_lerp = 0.0

var hover_tween:Tween
var pickup_tween:Tween
var position_tween:Tween

func animate_hover(state:bool, instant:bool = false):
	if hover_tween:
		hover_tween.kill()
	
	if instant:
		if state:
			scale = Vector2(expand_scale, expand_scale)
		else:
			scale = Vector2(1, 1)
		return
	
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
	
