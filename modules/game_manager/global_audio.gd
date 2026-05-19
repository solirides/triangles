extends Node

var sounds = {
	"shoot":preload("res://assets/sounds/shoot_2.wav"),
	"enemy_shoot":preload("res://assets/sounds/shoot_1.wav"),
	"enemy_hit":preload("res://assets/sounds/hit_1.wav"),
	"player_hit":preload("res://assets/sounds/hit_3.wav"),
	"slice":preload("res://assets/sounds/slice.wav"),
	"card":preload("res://assets/sounds/card.wav"),
	"laser":preload("res://assets/sounds/laser.mp3"),
	"shotgun":preload("res://assets/sounds/shotgun.wav")
}

var db_adjustments = {
	"laser":-6,
	"shotgun":-10
}

#@onready var audio_player = $AudioStreamPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func play(sound:String):
	#print(sound)
	var a:AudioStreamPlayer2D = AudioStreamPlayer2D.new()
	var res = sounds[sound]
	if res == null:
		return
	a.stream = res
	a.bus = "player"
	a.panning_strength = 0
	if sound in db_adjustments.keys():
		a.volume_db = db_adjustments[sound]
	add_child(a)
	a.play()
