class_name CombatLevel
extends Resource

@export var enemy_waves:Array[EnemyWave] = []

func _init(p_enemy_waves:Array[EnemyWave] = []):
	enemy_waves = p_enemy_waves

static func generate_combat_level(level:int):
	var c = CombatLevel.new()
	var wave_count = max(1, 1 + int(MathStuff.random_exponential(level, 1.04, 12, 1.60)))
	
	for i in wave_count:
		var w = EnemyWave.new()
		var sequence_count = max(1, 1 + int(MathStuff.random_exponential(level, 1.06, 7, 1.10)))
		for j in sequence_count:
			var s = EnemySequence.new()
			# avoid Enemy.EnemyType.NONE
			s.enemy_type = randi_range(1, Enemy.EnemyType.size() - 1)
			s.count =  max(1, 1 + int(MathStuff.random_exponential(level, 1.11, 6.00, 5.20)))
			s.duration = randf_range(1,4)
			s.pattern = EnemySequence.Pattern.RANDOM
			w.sequences.append(s)
		c.enemy_waves.append(w)
	
	return c
	
