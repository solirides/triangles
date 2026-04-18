extends Control

@export var card_size = Vector2(120,160)
@export var max_tilt = 0.15
@export var curvature = 0.17
@export var curvature_2 = 1.2
@export var rise = 40


@onready var card_placeholder_scene = preload("res://modules/hud/card_placeholder.tscn")
@onready var placeholders = $"../Placeholders"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	arrange_hand(true)
	for i in get_children():
		print(i.position)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	#check_combination()
	arrange_hand()

func get_cards(parent:Node = self):
	var cards = []
	for n in parent.get_children():
		if n is GuiCard:
			cards.append(n)
	return cards


func arrange_hand(force_update:bool = false):
	var hand_bounds = size
	var cards = get_cards()
	#hand_bounds.x = hand_bounds.x * card_size * cards.size()
	
	if cards.size() == 1:
		var pos = -cards[0].size / 2.0
		var rot = 0
		cards[0].position = pos
		cards[0].rotation = rot
	else:
		for i in cards.size():
			var a = i / (float(cards.size() - 1))
			var pos = Vector2(a * hand_bounds.x, 0)
			var centered_pos = pos - hand_bounds / 2.0
			var r = hand_bounds.x / 2.0 * curvature_2
			pos.y -= sqrt((r)**2 - (centered_pos.x)**2) * curvature
			pos -= cards[i].size / 2.0
			var rot = lerp_angle(-max_tilt, max_tilt, i / (float(cards.size() - 1)))
			
			#var placeholder_focused = false
			var focus = false
			var exists = false
			if cards[i].position_placeholder != null:
				exists = true
				#if cards[i].position_placeholder.focused:
					#placeholder_focused = true
			if cards[i].focused or cards[i].picked:
				#print("focused" + str(Time.get_ticks_msec()))
				focus = true
				if exists == false:
					#print("create placeholder" + str(Time.get_ticks_msec()))
					var p = card_placeholder_scene.instantiate()
					#p.position = cards[i].position
					p.position = cards[i].get_global_rect().position - placeholders.get_global_rect().position
					p.rotation = cards[i].rotation
					p.card = cards[i]
					placeholders.add_child(p)
					cards[i].position_placeholder = p
					p.set_global_position(cards[i].global_position)
				
				pos.y -= rise
			else:
				if exists:
					cards[i].position_placeholder.queue_free()
			
			#print(str(focus) + str(Time.get_ticks_msec()))
			
			if focus != cards[i].previous_focus or force_update:
				cards[i].previous_focus = focus
				#var tween = cards[i].position_tween
				#var gpos = cards[i].get_global_position()
				if cards[i].position_tween:
					print("kill tween")
					cards[i].position_tween.kill()
					#cards[i].set_global_position(gpos)
					
				cards[i].position_tween = cards[i].create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
				#tween.tween_property(cards[i], "position", pos, 0.3)
				cards[i].position_tween.tween_property(cards[i], "position", pos, 0.3)
				print(pos)
				
				#await tween.finished
			
			#cards[i].position = pos
			cards[i].rotation = rot
	
