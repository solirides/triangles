extends Node2D

@export var level_size:Vector2 = Vector2(500, 300)
@export var enemy_waves:Array[EnemyWave] = []

@onready var world_boundary = $Node2D/StaticBody2D

var spawning_telegraph = preload("res://modules/enemy/spawning_telegraph.tscn")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# top tier programming practices right here
	# I will be surprised if this doesn't break at some point
	var distance = [level_size.y, level_size.x, level_size.y, level_size.x]
	var normal = [Vector2(0,-1), Vector2(1, 0), Vector2(0,1), Vector2(-1, 0)]
	for i in range(4):
		var shape = world_boundary.get_children()[i]
		shape.shape.distance = -distance[i]
		shape.shape.normal = normal[i]
	world_boundary.get_children()[4].polygon = PackedVector2Array([Vector2(level_size.x, level_size.y), Vector2(-level_size.x, level_size.y), Vector2(-level_size.x, -level_size.y), Vector2(level_size.x, -level_size.y)])
	
	spawn_enemy_wave()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func spawn_enemy_wave():
	
	for i in range(10):
		var random = Vector2()
		random.x = randf_range(-level_size.x, level_size.x)
		random.y = randf_range(-level_size.y, level_size.y)
		
		spawn_enemy("turret", random)

func spawn_enemy(enemy_type, position) -> Node:
	var a = spawning_telegraph.instantiate()
	
	a.global_position = position
	a.queued_enemy = enemy_type
	
	self.add_child(a)
	
	return a
