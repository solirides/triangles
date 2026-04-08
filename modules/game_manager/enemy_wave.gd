class_name EnemyWave
extends Resource

@export var sequences:Array[EnemySequence] = []

func _init(p_sequences:Array[EnemySequence] = []):
	sequences = p_sequences
	
