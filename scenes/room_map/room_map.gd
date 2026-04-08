extends Node2D

# y
@export var max_width = 10
# x
@export var max_length = 10

@export var display_scale = Vector2(30,20)

var room_scene = preload("res://scenes/room_map/room.tscn")

var rooms = []
var hallways = []

enum ROOM {
	EMPTY,
	ROOM,
	PASSAGE
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	generate_room()
	display_rooms()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

# this is absolute spaghetti code
func generate_room():
	# ARRAYS ARE ALWAYS PASSED BY REFERENCE
	var row = []
	row.resize(max_width + 2)
	row.fill(ROOM.EMPTY)
	
	var rooms = []
	rooms.resize(max_length + 2)
	for i in rooms.size():
		rooms[i] = row.duplicate()
	#rooms.fill(row.duplicate())
	
	row.fill([])
	var hallways = []
	hallways.resize(max_length + 2)
	for i in hallways.size():
		hallways[i] = row.duplicate()
	#hallways.fill(row.duplicate())
	
	#var passages = rooms.duplicate()
	var abc = (max_width + 1)/ 2
	rooms[1][abc] = ROOM.ROOM
	
	# y of live paths
	var live_paths = [abc]
	var next_live_paths = []
	# number of times this y value has consecutively been in live_paths
	var path_length = []
	path_length.resize(max_width + 2)
	path_length.fill(0)
	
	var fork_p = 0.3
	var merge_p = 0.8
	var min_path_length = 2
	var max_path_count = 3
	# useable cell indexes are from 1 to max value
	
	randomize()
	#seed(1234)
	# for each row (vertical)
	for x in range(1, max_length + 1):
		# for each cell
		#for y in range(1, max_width - 1):
		for y in live_paths:
			print(str(x) + " " + str(y))
			#if rooms[x][y] != ROOM.EMPTY:
			var r = randf()
			var continue_path = true
			if r < fork_p and next_live_paths.size() < max_path_count:
				# attempt to fork up or down
				if randf() < 0.5 and y+1 <= max_width:
					rooms[x+1][y+1] = ROOM.ROOM
					next_live_paths.append(y+1)
					hallways[x][y].append([x+1,y+1])
				elif y-1 >= 1:
					rooms[x+1][y-1] = ROOM.ROOM
					next_live_paths.append(y-1)
					hallways[x][y].append([x+1,y-1])
			elif fork_p < r and r < fork_p + merge_p and path_length[y] >= min_path_length:
				# attempt merge
				# randomly chose which direction is favored
				var sign = -1 + 2 * int(randf() < 0.5)
				for j in range(0, max_width + 2):
					var jmod = (sign*j + y) % (max_width + 2)
					if rooms[x+1][jmod] == ROOM.ROOM:
						# successful merge
						next_live_paths.append(jmod)
						continue_path = false
						break
			
			if continue_path:
				# continue path
				rooms[x+1][y] = ROOM.ROOM
				next_live_paths.append(y)
				hallways[x][y].append([x+1,y])
			
				
			#else:
				#var neighbors = (rooms[x-1][y-1] != ROOM.EMPTY) + (rooms[x-1][y+1] != ROOM.EMPTY)
				#if randf() < neighbors * 0.3:
					#pass
				#
		
		# probably not efficient
		for i in range(max_width + 2):
			if live_paths.has(i) and next_live_paths.has(i):
				path_length[i] += 1
			else:
				path_length[i] = int(next_live_paths.has(i))
		
		live_paths = next_live_paths
		next_live_paths = []
	
	self.rooms = rooms
	self.hallways = hallways

func display_rooms():
	for x in range(1, max_length  + 1):
		for y in range(1, max_width  + 1):
			if rooms[x][y] == ROOM.ROOM:
				var a = room_scene.instantiate()
				var offset = -get_viewport().size.x / 2.0
				#print(offset)
				a.global_position = Vector2(x * display_scale.x + offset, y * display_scale.y - (max_width+2)/2*display_scale.y)
				add_child(a)

# 00r=r=r=r
# 00=00000=
# r=r=r=r=r=r
# 0000=
# 0000r=r=r=r

#func get_neighbors(rooms:Array):
