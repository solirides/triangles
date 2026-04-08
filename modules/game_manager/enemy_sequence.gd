class_name EnemySequence
extends Resource

@export var enemy_type:String
@export var count:int
@export var duration:float
@export var pattern:int

enum PATTERN {
	NONE,
	RANDOM
}

func _init(p_enemy_type, p_count, p_duration, p_pattern):
	enemy_type = p_enemy_type
	count = p_count
	duration = p_duration
	pattern = p_pattern
