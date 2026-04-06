extends Node2D


@export var max_width = 5
@export var max_length = 10


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func generate_room():
	var row = []
	row.resize(max_width + 1)
	row.fill("empty")
	
	var rooms = []
	rooms.resize(max_length + 1)
	rooms.fill(row.duplicate())
	
	# for each row
	for x in range(2, max_length.size() - 1):
		# for each cell
		for y in range(1, max_width.size() - 1):
			if rooms[x-1][y] != "empty":
				# continue path
				rooms[x][y] = "room1"
			else:
				var neighbors = (rooms[x-1][y-1] != "empty") + (rooms[x-1][y+1] != "empty")
				if randf() < neighbors * 0.3:
					pass

#func get_neighbors(rooms:Array):
