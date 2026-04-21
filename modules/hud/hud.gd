extends Control

@export var card_container:Node = null
@onready var tint_node = $Tint
@onready var health_bar = $VBoxContainer/HBoxContainer/HealthBar
@onready var health_label = $VBoxContainer/HBoxContainer/Health
@onready var random_label = $VBoxContainer/Label
@onready var level_label = $VBoxContainer2/Level
@onready var enemies_label = $VBoxContainer2/Enemies

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	tint_node.modulate = Color(1,1,1,0)
	card_container.modulate = Color(1,1,1,0)
	GameManager.player_node_ready.connect(_on_player_ready)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var text = "FPS: " + str(Engine.get_frames_per_second())
	random_label.text = text
	if GameManager.ready_state_bool:
		if GameManager.world_node != null:
			level_label.text = "Level: " + str(GameManager.player_level) + "   Wave: " + str(GameManager.world_node.wave_i + 1)
	enemies_label.text = "Enemies remaining: " + str(get_tree().get_nodes_in_group("enemy").size())
	
	var a = GameManager.player.get_stat("health")
	var b = GameManager.player.get_stat("health", "modified_value")
	health_bar.value = a
	health_bar.max_value = b
	health_label.text = str(int(a)) + "/" + str(int(b))

func _on_player_ready():
	pass

var tint_tween:Tween
func animate_background_tint(state:bool):
	if tint_tween:
		tint_tween.kill()
	tint_tween = create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	if state:
		tint_tween.tween_property(tint_node, "modulate", Color(1,1,1,1), 0.3)
	else:
		tint_tween.tween_property(tint_node, "modulate", Color(1,1,1,0), 0.15)
	
	#tween.finished.connect(_on_tween_finished)

var card_hand:Tween
func show_card_hand(state:bool):
	if card_hand:
		card_hand.kill()
	card_hand = create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	if state:
		card_hand.tween_property(card_container, "modulate", Color(1,1,1,1), 0.15)
	else:
		card_hand.tween_property(card_container, "modulate", Color(1,1,1,0), 0.15)
	

func _on_card_hand_gui_input(event: InputEvent) -> void:
	pass # Replace with function body.
