extends Node2D

@export var level_size:Vector2 = Vector2(500, 300)
@export var enemy_waves:Array[EnemyWave] = []

@onready var world_boundary = $WorldBoundary

var spawning_telegraph = preload("res://modules/enemy/spawning_telegraph.tscn")

#var enemy_nodes:Array[Node] = []
var wave_i = 0
var wave_fully_deployed = false
var level_started = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameManager.enemy_death.connect(_on_enemy_death)
	GameManager.set_in_world(true)
	
	## top tier programming practices right here
	## I will be surprised if this doesn't break at some point
	#var distance = [level_size.y, level_size.x, level_size.y, level_size.x]
	#var normal = [Vector2(0,-1), Vector2(1, 0), Vector2(0,1), Vector2(-1, 0)]
	#for i in range(4):
		#var shape = world_boundary.get_children()[i]
		#shape.shape.distance = -distance[i]
		#shape.shape.normal = normal[i]
	#world_boundary.get_children()[4].polygon = PackedVector2Array([Vector2(level_size.x, level_size.y), Vector2(-level_size.x, level_size.y), Vector2(-level_size.x, -level_size.y), Vector2(level_size.x, -level_size.y)])

func start_level():
	if level_started == false:
		level_started = true
		world_boundary.change_level_collisions("combat")
		spawn_enemy_wave(wave_i)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
	#print(get_tree().get_nodes_in_group("enemy").size())
	try_next_wave()

func spawn_enemy_wave(wave_i):
	var wave = enemy_waves[wave_i]
	print(wave)
	var wave_time = 0
	for sequence:EnemySequence in wave.sequences:
		#print("sequence")
		for i in range(sequence.count):
			#print("count")
			var pos = Vector2()
			match sequence.pattern:
				_:
					pos.x = randf_range(-level_size.x, level_size.x)
					pos.y = randf_range(-level_size.y, level_size.y)
			
			#sequence.duration
			get_tree().create_timer(sequence.duration * i / sequence.count).timeout.connect(func(): spawn_enemy(sequence.enemy_type, pos))
		wave_time += sequence.duration
	
	get_tree().create_timer(wave_time).timeout.connect(func(): wave_fully_deployed = true)

func spawn_enemy(enemy_type, position) -> Node:
	var a = spawning_telegraph.instantiate()
	
	a.global_position = position
	a.queued_enemy = enemy_type
	a.target = GameManager.player
	
	self.add_child(a)
	
	return a

func _on_enemy_death():
	pass
	#print("enemy death")
	#print(GameManager.enemy_nodes.size())
	#get_tree().get_nodes_in_group("enemy").size()
	
	# wait for last enemy queue_free()
	#await get_tree().process_frame
	#try_next_wave()

func try_next_wave():
	#print(get_tree().get_nodes_in_group("enemy").size())
	if wave_i >= enemy_waves.size() - 1:
		print("level complete")
		world_boundary.change_level_collisions("end")
	elif get_tree().get_nodes_in_group("enemy").size() == 0 and wave_fully_deployed == true:
		wave_i += 1
		wave_fully_deployed = false
		spawn_enemy_wave(wave_i)
