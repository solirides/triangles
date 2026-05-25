extends Node2D

### max x and y distance from center for spawnable area
@export var level_size:Vector2 = Vector2(500, 300)
@export var enemy_waves:Array[EnemyWave] = []
@export var combat_level:CombatLevel

@onready var world_boundary = $WorldBoundary

var spawning_telegraph = preload("res://modules/enemy/spawning_telegraph.tscn")

#var enemy_nodes:Array[Node] = []
var wave_i = 0
var wave_fully_deployed = false
var level_started = false
var level_ended = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameManager.world_node = self
	GameManager.enemy_death.connect(_on_enemy_death)
	
	combat_level = CombatLevel.generate_combat_level(GameManager.player_level)
	
	GameManager.ready_state["world"] = true
	GameManager.set_in_world(true)
	

func start_level():
	print("start level")
	if level_started == false:
		level_started = true
		world_boundary.change_level_collisions("combat")
		spawn_enemy_wave(wave_i)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
	#print(get_tree().get_nodes_in_group("enemy").size())
	if level_started:
		try_next_wave()

func spawn_enemy_wave(wave_i):
	var wave = combat_level.enemy_waves[wave_i]
	#print(wave)
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
	
	# should be greater than time for spawning telegraph to create enemy
	var margin:float = 3
	get_tree().create_timer(wave_time + margin).timeout.connect(func(): wave_fully_deployed = true)

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
	# if current wave is complete
	if get_tree().get_nodes_in_group("enemy").size() == 0 and level_started and wave_fully_deployed:
		if wave_i >= combat_level.enemy_waves.size() - 1:
			if level_ended == false:
				level_ended = true
				print("level complete")
				print("enemy count " + str(get_tree().get_nodes_in_group("enemy").size()) + ", wave_i " + str(wave_i) )
				
				world_boundary.change_level_collisions("end")
		else:
			wave_fully_deployed = false
			wave_i += 1
			spawn_enemy_wave(wave_i)
