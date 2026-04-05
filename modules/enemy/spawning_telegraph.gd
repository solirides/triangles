extends Node2D

var queued_enemy = "turret"
var tween:Tween = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	start_spawning_sequence()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func start_spawning_sequence():
	tween = self.create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	for i in range(3):
		tween.tween_property(self, "modulate", Color(1,1,1,0), 0.4)
		tween.tween_property(self, "modulate", Color(1,1,1,0.5), 0.4)
	for i in range(3):
		tween.tween_property(self, "modulate", Color(1,1,1,0), 0.1)
		tween.tween_property(self, "modulate", Color(1,1,1,0.5), 0.1)
	tween.tween_callback(spawn_enemy)

func spawn_enemy():
	var scene = load("res://modules/enemy/" + queued_enemy + ".tscn")
	var a = scene.instantiate()
	a.global_position = self.global_position
	get_tree().root.add_child(a)
	self.queue_free()
