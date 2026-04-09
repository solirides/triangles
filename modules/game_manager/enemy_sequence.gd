class_name EnemySequence
extends Resource

@export var enemy_type:Enemy.ENEMY_TYPE
@export var count:int
@export var duration:float
@export var pattern:PATTERN

enum PATTERN {
	NONE,
	RANDOM
}

func _init(p_enemy_type = Enemy.ENEMY_TYPE.NONE, p_count = 0, p_duration = 0, p_pattern = PATTERN.RANDOM):
	enemy_type = p_enemy_type
	count = p_count
	duration = p_duration
	pattern = p_pattern
