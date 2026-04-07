extends Node2D


@export var max_width = 5
@export var max_length = 10

enum ROOM {
	EMPTY,
	ROOM,
	PASSAGE
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func generate_room():
	var row = []
	row.resize(max_width + 1)
	row.fill(ROOM.EMPTY)
	
	var rooms = []
	rooms.resize(max_length + 1)
	rooms.fill(row.duplicate())
	
	#var passages = rooms.duplicate()
	
	
	# for each row
	for x in range(2, max_length.size() - 1):
		# for each cell
		for y in range(1, max_width.size() - 1):
			if rooms[x-1][y] != ROOM.EMPTY:
				# continue path
				rooms[x][y] = ROOM.ROOM
			else:
				var neighbors = (rooms[x-1][y-1] != ROOM.EMPTY) + (rooms[x-1][y+1] != ROOM.EMPTY)
				if randf() < neighbors * 0.3:
					pass

# 00r=r=r=r
# 00=00000=
# r=r=r=r=r=r
# 0000=
# 0000r=r=r=r

#func get_neighbors(rooms:Array):
