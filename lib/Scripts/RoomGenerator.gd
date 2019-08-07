extends TileMap


export var cell_countw:int
export var cell_counth:int
export var chest_rooms:int = 5
export var desired_rooms:int = 25
onready var room_instances:Array = []
onready var edge_set:UnsortedSet = UnsortedSet.new()
onready var platforms:Array = []
onready var pushers:Array = []
onready var dfs_spreadable_one:int
onready var dfs_spreadable_two:int
onready var enemies:Array
onready var room_children:Array = []
onready var lock:bool = false
onready var visited_rooms:UnsortedSet = UnsortedSet.new()
onready var neighbour_visited_rooms:UnsortedSet = UnsortedSet.new()
onready var visited_edges = UnsortedSet.new()
const MIN_WIDTH = 15
const MIN_HEIGHT = 15
const MAX_WIDTH = 45
const MAX_HEIGHT = 20
const MEAN_WIDTH = (MIN_WIDTH + MAX_WIDTH) / 2
const MEAN_HEIGHT = (MIN_HEIGHT + MAX_HEIGHT) / 2
const CHANCE_BACK_EDGE = 0.25
const PUSHER_FACTORY = preload("res://Scenes/PusherFactory.tscn")
const ROOM_SCENES:Array = [preload("res://PresetRooms/SpawnRoom.tscn"), preload("res://PresetRooms/ChestRoom.tscn"), 
		preload("res://PresetRooms/Shop.tscn"),
		preload("res://PresetRooms/Room1.tscn")] 


# Init
func _ready():
	dfs_spreadable_one = tile_set.find_tile_by_name("DarkPurpleBrick")
	dfs_spreadable_two = tile_set.find_tile_by_name("RedBrick")
	randomize()
	generate_dungeon_2()


# Generates an Isaac style dungeon
func generate_dungeon_2():
	reset()
	isaac_generate()
	prim_connect()
	for i in range(room_instances.size()):
		room_instances[i].type = int(rand_range(3, ROOM_SCENES.size()))
	room_instances[0].type = 0
	room_instances[1].type = 2
	for i in range(chest_rooms):
		room_instances[i + 2].type = 1
	display()


# Initialize arrays and clear tilemap
func reset():
	room_instances = []
	edge_set = UnsortedSet.new()
	platforms = []
	for child in room_children:
		child.queue_free()
	room_children = []
	enemies = []
	lock = false
	clear()


# Generate the Isaac style grid of room_instances in complete form
func isaac_generate():
	var rooms_widths:int = cell_countw / (MEAN_WIDTH + GlobalVariables.BORDER)
	var rooms_lenghts:int = cell_counth / (MEAN_HEIGHT + GlobalVariables.BORDER)
	for w in range(rooms_widths):
		for h in range(rooms_lenghts):
			var p:Point = Point.new(w * (MEAN_WIDTH + GlobalVariables.BORDER),
						h * (MEAN_HEIGHT + GlobalVariables.BORDER))
			room_instances.append(Rect.new(MEAN_WIDTH, MEAN_HEIGHT, p, true))
	# Mix up order of array so there isn't any bias
	room_instances.shuffle()


# Starting with a random room, create a spanning tree of rooms that 
# is more weighted around the starting room. Edges never overlap.
func prim_connect():
	var weighted_matrix:Array = fill_weighted_matrix()
	var adjacency_matrix:Array = build_2d_array(room_instances.size(), room_instances.size())
	var root:int = int(rand_range(0, room_instances.size()))
	var tree:Array = []
	tree.append(root)
	while tree.size() < desired_rooms:
		# Make spanning tree
		var neighbours:UnsortedSet = get_neighbours(adjacency_matrix, weighted_matrix, tree)
		if neighbours != null:
			for i in neighbours.data:
				var child:int = int(neighbours.grab())
				var parent:int = -1
				for j in tree:
					# If room_instances are beside one another
					if weighted_matrix[child][j] == GlobalVariables.BORDER:
						parent = j
						adjacency_matrix[parent][child] = 1
						adjacency_matrix[child][parent] = 1
						if !has_cycle(adjacency_matrix):
							var e:Edge = Edge.new(room_instances[parent], room_instances[child])
							edge_set.add(e)
							tree.append(child)
							break
						else:
							adjacency_matrix[parent][child] = 0
							adjacency_matrix[child][parent] = 0
				# If a parent has been found, make this edge unavailable
				if parent >= 0:
					weighted_matrix[parent][child] = 100000
					weighted_matrix[child][parent] = 100000
					break
	# If the tree does not contain a room, mark as visited
	for i in range(room_instances.size()):
		for j in range(tree.size()):
			if i == tree[j]:
				room_instances[i].visited = false
				break
	# Remove all visited rooms
	var rs:int = room_instances.size()
	for i in range(1, rs + 1):
		if room_instances[rs - i].visited:
			room_instances.remove(rs - i)
	# Add in back edges
	weighted_matrix = build_2d_array(room_instances.size(), room_instances.size())
	for i in range(weighted_matrix.size()):
		var r:Node = room_instances[i]
		for j in range(weighted_matrix.size()):
			if i == j:
				weighted_matrix[i][j] = 100000
			else:
				weighted_matrix[i][j] = r.dist_adjacency(room_instances[j])
				if weighted_matrix[i][j] == GlobalVariables.BORDER && rand_range(0,1) < CHANCE_BACK_EDGE:
					edge_set.add(Edge.new(room_instances[i], room_instances[j]))


# Return an array of rooms that are GlobalVariables.BORDER away from this one.
#	adjacency_matrix - Adjacency matrix of current graph.
#	weighted_matrix - Weighted adjacency matrix.
#	tree - Current members of tree.
#	return - Set of all adjacency non-members of tree.
func get_neighbours(adjacency_matrix:Array, weighted_matrix:Array, tree:Array) -> UnsortedSet:
	var neighbours:UnsortedSet = UnsortedSet.new()
	for i in range(tree.size()):
		for j in range(weighted_matrix[tree[i]].size()):
			if weighted_matrix[tree[i]][j] == GlobalVariables.BORDER && adjacency_matrix[tree[i]][j] == 0:
				neighbours.add(j)
	return neighbours


# Checks an adjacency matrix for existence of cycles.
#	adj - Adjacency matrix to check
#	return - Does the matrix have a cycle? 
func has_cycle(adj:Array) -> bool:
	var visited:UnsortedSet = UnsortedSet.new()
	for i in range(adj.size()):
		if visited.contains(i):
			continue
		if dfs(i,visited, -1, adj):
			return true
	return false


# Performs a depth-first search upon an adjacency matrix.
#	matrix - Adjacency matrix to search
#	return - Found a back edge?	
func dfs(vertex:int, visited:UnsortedSet, parent:int, adj:Array) -> bool:
	visited.add(vertex)
	for i in range(adj.size()):
		if adj[vertex][i] == 1:
			if i == parent:
				continue
			if visited.contains(i):
				return true
			if 	dfs(i, visited,vertex, adj):
				return true
	return false


# Displays the image of each room and edge on the TileMap
func display():
	for edge in edge_set.data:
		edge.image_walls(self)
	for room in room_instances:
		room.image_ext(self)
	for edge in edge_set.data:
		edge.image_empty(self,true)
	for room in room_instances:
		var r1:Node = ROOM_SCENES[room.type].instance()
		room.image_int(self)
		r1.position = map_to_world(Vector2(room.low.x + 1, room.low.y + 1))
		add_child(r1)
		room_children.append(r1)
		if r1.has_node("Enemies"):
			var temp:Node = r1.get_node("Enemies")
			enemies.append(temp)
			r1.remove_child(temp)
		else:
			enemies.append(null)


# Returns the cneter of the room of type 0. This room has no enemies.
#	return - Location of spawn room.
func spawn_room() -> Vector2:
	var spawn = Vector2((room_instances[0].xsize/2) + room_instances[0].low.x,
			(room_instances[0].ysize/2) + room_instances[0].low.y)
	spawn *= 32 
	return spawn


# Returns the midpoint of some arbitrary room
# return - Vector2 spawn point
func arbitrary_room() -> Vector2:
	var t:int = int(rand_range(0,room_instances.size()))
	# Set t to be a spawn room
	var spawn:Vector2 = Vector2((room_instances[t].xsize/2) + room_instances[t].low.x,
			(room_instances[t].ysize/2) + room_instances[t].low.y)
	spawn *= 32
	return spawn


# Finds room target is inside. Opens all hallways connected to room.
#	position - Position vector of target
func open_doors(position:Vector2):
	if lock == true:
		return
	get_parent().start_hall_timer()
	for pusher in pushers:
		pusher.purge()
		pusher.queue_free()
	pushers = []
	$Effects.clear()
	var current_room_index:int = find_player_index(position)
	var current_room:Node = room_instances[current_room_index]
	var d:Array = []
	var dn:Array = []
	for edge in edge_set.data:
		edge.image_empty(self,false)
		if edge.contains(current_room):
			d.append(edge.get_doors(current_room))
			dn.append(edge.get_door_normals(current_room))
	if d != null:
		for i in range(d.size()):
			var pf:Node = PUSHER_FACTORY.instance()
			pf.tilemap_position = d[i]
			pf.direction = dn[i]
			pushers.append(pf)
			add_child(pf)
			pf.dfs_spread(dfs_spreadable_one)
			var pf2:Node = PUSHER_FACTORY.instance()
			if dn[i].x != 0:
				pf2.tilemap_position = Vector2(d[i].x, d[i].y + 1)
			else:
				pf2.tilemap_position = Vector2(d[i].x + 1, d[i].y)
			pf2.direction = dn[i]
			pushers.append(pf2)
			add_child(pf2)
			pf2.dfs_spread(dfs_spreadable_two)
	for room in room_instances:
		room.image_int(self)


# Shuts every door in the edge set.
func close_doors():
	for edge in edge_set.data:
		edge.image_empty(self,true)


# Determines where the player is and returns it as a Rect
#	position - Player's world position
#	return - Rect of where Player is, or null if player is in a hallway
func find_player(position:Vector2):
	var tpos:Vector2 = world_to_map(position)
	for room in room_instances:
		if room.is_target_inside(tpos):
			return room
	return null


# Determine what room the player is in and return its index in
# the rooms array. 
#	position - Player's world position
#	return - Index of room in rooms array where player is or -1 if 
#			 in hallway.
func find_player_index(position:Vector2):
	var current_room:int = -1
	var tpos:Vector2 = world_to_map(position)
	for i in range(room_instances.size()):
		if room_instances[i].is_target_inside(tpos):
			return i
	return current_room


# Add the children of a room's Enemies node
# Only works if enemies have not already been killed 
# in that room.
#	room_index - Index to spawn enemies of.
func spawn_enemies(room_index:int):
	if room_index >= chest_rooms + 2 && room_children[room_index].cleared != true:
		room_children[room_index].add_child(enemies[room_index])
		enemies[room_index].update_material(self.material)
		lock = true


# Kill every enemy in a room of the specified index
#	room_index - Room index to kill enemies in
func kill_enemies(room_index:int):
	if room_index >= chest_rooms + 2 && room_children[room_index].cleared != true:
		for enemy in enemies[room_index].get_children():
			enemy.take_damage(1000000, Vector2(0, 0))


# Take an array and turn it into an 2d array of zero
#	width - Number of rows in array
#	height - Number of cols in array
#	return - 2d filled with 0
func build_2d_array(width:int, height:int) -> Array:
	assert width > 0 
	assert height > 0
	var arr:Array = []
	#warning-ignore:unused_variable
	for i in range(width):
		arr.append([])
	#warning-ignore:unused_variable
		for j in range(height):
			arr[i].append(0)
	return arr


# Takes in an array of rooms an will create a weighted adjacency matrix
#	return - Weighted adjacency matrix
func fill_weighted_matrix() -> Array:
	var weighted_matrix:Array = build_2d_array(room_instances.size(), room_instances.size())
	for i in range(weighted_matrix.size()):
		var r:Node = room_instances[i]
		for j in range(weighted_matrix[i].size()):
			if i == j:
				weighted_matrix[i][j] = 1000000
			else:
				weighted_matrix[i][j] = r.dist_adjacency(room_instances[j])
	return weighted_matrix


# Finds the lowest point on the grid in terms of x and y
#	return - lowest point on the gird
func minimal_corner() -> Vector2:
	var min_x:float = room_instances[0].low.x
	for room in room_instances:
		if room.low.x <= min_x:
			min_x = room.low.x
	var min_y:float = room_instances[0].low.y
	for room in room_instances:
		if room.low.y <= min_y:
			min_y = room.low.y
	return Vector2(min_x, min_y)


# Finds the maximum point on the grid in terms of x and y
#	return - the maximum point on the grid
func maximal_corner() -> Vector2:
	var max_x:float = room_instances[0].high.x
	for room in room_instances:
		if room.high.x >= max_x:
			max_x = room.high.x
	var max_y:float = room_instances[0].high.y
	for room in room_instances:
		if room.high.y >= max_y:
			max_y = room.high.y
	return Vector2(max_x, max_y)


# Updates the neighbours_visited by adding all the neighbours of the current index
#	index - Index to add neighbours of
func get_connected_neighbours(index:int):
	var current_room:Node = room_instances[index]
	for edge in edge_set.data:
		if edge.contains(current_room):
			visited_edges.add(edge)
			for room in room_instances:
				if edge.contains(room):
					neighbour_visited_rooms.add(room)