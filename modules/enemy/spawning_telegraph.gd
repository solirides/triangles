extends Node2D

@export var instant = false
var queued_enemy:Enemy.EnemyType = Enemy.EnemyType.TURRET
var tween:Tween = null
var target:Node

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	start_spawning_sequence()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func start_spawning_sequence():
	tween = self.create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	if instant == false:
		for i in range(3):
			tween.tween_property(self, "modulate", Color(1,1,1,0), 0.4)
			tween.tween_property(self, "modulate", Color(1,1,1,0.5), 0.4)
		for i in range(3):
			tween.tween_property(self, "modulate", Color(1,1,1,0), 0.1)
			tween.tween_property(self, "modulate", Color(1,1,1,0.5), 0.1)
	tween.tween_callback(spawn_enemy)

func spawn_enemy():
	var scene = load(Enemy.ENEMY_SCENES[queued_enemy])
	var a = scene.instantiate()
	a.global_position = self.global_position
	a.target = self.target
	get_tree().get_current_scene().add_child(a)
	#GameManager.enemy_nodes.append(a)
	a.death.connect(GameManager._on_enemy_death)
	self.queue_free()
