class_name EnemySequence
extends Resource

@export var enemy_type:Enemy.EnemyType
@export var count:int
@export var duration:float
@export var pattern:Pattern

enum Pattern {
	NONE,
	RANDOM
}

func _init(p_enemy_type = Enemy.EnemyType.NONE, p_count = 0, p_duration = 0, p_pattern = Pattern.RANDOM):
	enemy_type = p_enemy_type
	count = p_count
	duration = p_duration
	pattern = p_pattern
