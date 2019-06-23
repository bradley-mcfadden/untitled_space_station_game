extends TileMap

var UnsortedSet = load("res://Scripts/UnsortedSet.gd")
var Point = load("res://Scripts/Point.gd")
var Edge = load("res://Scripts/Edge.gd")
var Rect = load("res://Scripts/Rect.gd")
var PF = load("res://Scenes/PusherFactory.tscn")
var Room1 = preload("res://PresetRooms/Room1.tscn")
var ChestRoom = preload("res://PresetRooms/ChestRoom.tscn")
var SpawnRoom = preload("res://PresetRooms/SpawnRoom.tscn")
onready var RoomScenes = [SpawnRoom,ChestRoom,Room1]
onready var roomChildren = []
export var cell_countw:int
export var cell_counth:int
export var roomAttempts = 20
export var batch = 20
export var chest_rooms = 5
export var desiredRooms = 25
onready var rooms = []
onready var edgeSet = UnsortedSet.new()
onready var platforms = []
onready var Effects = $Effects
onready var pushers = []
onready var dg:int
onready var rg:int
onready var enemies:Array
onready var lock = false
const MIN_WIDTH = 15
const MIN_HEIGHT = 15
const MAX_WIDTH = 45
const MAX_HEIGHT = 20
const MEAN_WIDTH = (MIN_WIDTH + MAX_WIDTH)/2
const MEAN_HEIGHT = (MIN_HEIGHT + MAX_HEIGHT)/2
const CHANCE_BACK_EDGE = 0.25

# Init
func _ready():
	dg = tile_set.find_tile_by_name("DarkPurpleBrick")
	rg = tile_set.find_tile_by_name("RedBrick")
	randomize()
	generate_dungeon_2()

# Generates an Isaac style dungeon
func generate_dungeon_2():
	reset()
	isaac_generate()
	prim_connect()
	for i in range(rooms.size()):
		rooms[i].type = int(rand_range(2,RoomScenes.size()))
	rooms[0].type = 0
	for i in range(chest_rooms):
		rooms[i+1].type = 1
	display()
	
# Initialize arrays and clear tilemap
func reset():
	rooms = []
	edgeSet = UnsortedSet.new()
	platforms = []
	for child in roomChildren:
		child.queue_free()
	roomChildren = []
	clear()

# Generate the Isaac style grid of rooms in complete form
func isaac_generate():
	var px = cell_countw / (MEAN_WIDTH+GlobalVariables.BORDER)
	var py = cell_counth / (MEAN_HEIGHT+GlobalVariables.BORDER)
	for w in range(px):
		for h in range(py):
			var p = Point.new(w*(MEAN_WIDTH+GlobalVariables.BORDER),
			        h*(MEAN_HEIGHT+GlobalVariables.BORDER))
			rooms.append(Rect.new(MEAN_WIDTH,MEAN_HEIGHT,p,true))
	# Mix up order of array so there isn't any bias
	rooms.shuffle()

# Starting with a random room, create a spanning tree of rooms that 
# is more weighted around the starting room. Edges never overlap.
func prim_connect():
	var weightMatrix = []
	for i in range(rooms.size()):
		weightMatrix.append([])
		for j in range(rooms.size()):
			weightMatrix[i].append(0)
		
	for i in range(weightMatrix.size()):
		var r = rooms[i]
		for j in range(weightMatrix[i].size()):
			if i == j:
				weightMatrix[i][j] = 1000000
			else:
				weightMatrix[i][j] = r.dist_adjacency(rooms[j])
	var adjMatrix = []
	for i in range(rooms.size()):
		adjMatrix.append([])
		for j in range(rooms.size()):
			adjMatrix[i].append(0)
	var root = int(rand_range(0,rooms.size()))
	var tree = []
	tree.append(root)
	# print(tree)
	# print(get_neighbours(adjMatrix,weightMatrix,tree).data)
	while tree.size() < desiredRooms:
		# Make spanning tree
		var neighbours = get_neighbours(adjMatrix, weightMatrix, tree)
		if neighbours != null:
			for i in neighbours.data:
				var child = int(neighbours.grab())
				var parent = -1
				for j in tree:
					# If rooms are beside one another
					if weightMatrix[child][j] == GlobalVariables.BORDER:
						parent = j
						adjMatrix[parent][child] = 1
						adjMatrix[child][parent] = 1
						if !has_cycle(adjMatrix):
							var e = Edge.new(rooms[parent],rooms[child])
							edgeSet.add(e)
							tree.append(child)
							break
						else:
							adjMatrix[parent][child] = 0
							adjMatrix[child][parent] = 0
				# If a parent has been found, make this edge unavailable
				if parent >= 0:
					weightMatrix[parent][child] = 100000
					weightMatrix[child][parent] = 100000
					break

	# If the tree does not contain a room, mark as visited
	for i in range(rooms.size()):
		for j in range(tree.size()):
			if i == tree[j]:
				rooms[i].visited = false
				break
	# Remove all visited rooms
	var rs = rooms.size()
	for i in range(1,rs+1):
		if rooms[rs-i].visited:
			rooms.remove(rs-i)
			
	# Add in back edges
	weightMatrix = []
	for i in range(rooms.size()):
		weightMatrix.append([])
		for j in range(rooms.size()):
			weightMatrix[i].append(0)
			
	for i in range(weightMatrix.size()):
		var r = rooms[i]
		for j in range(weightMatrix.size()):
			if i == j:
				weightMatrix[i][j] = 100000
			else:
				weightMatrix[i][j] = r.dist_adjacency(rooms[j])
				if weightMatrix[i][j] == GlobalVariables.BORDER && rand_range(0,1) < CHANCE_BACK_EDGE:
					edgeSet.add(Edge.new(rooms[i],rooms[j]))

# Return an array of rooms that are GlobalVariables.BORDER away from this one.
#	adjMatrix - Adjacency matrix of current graph.
#	weightMatrix - Weighted adjacency matrix.
#	tree - Current members of tree.
#	return - Set of all adjacency non-members of tree.
func get_neighbours(adjMatrix:Array,weightMatrix:Array,tree:Array) -> UnsortedSet:
	var neighbours = UnsortedSet.new()
	for i in range(tree.size()):
		for j in range(weightMatrix[tree[i]].size()):
			if weightMatrix[tree[i]][j] == GlobalVariables.BORDER && adjMatrix[tree[i]][j] == 0:
				neighbours.add(j)
	return neighbours

# Checks an adjacency matrix for existence of cycles.
#	adj - Adjacency matrix to check
#	return - Does the matrix have a cycle? 
func has_cycle(adj:Array) -> bool:
	var visited = UnsortedSet.new()
	for i in range(adj.size()):
		if visited.contains(i):
			continue
		if dfs(i,visited,-1,adj):
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
			if 	dfs(i,visited,vertex,adj):
				return true
	return false

# Displays the image of each room and edge on the TileMap
func display():
	for edge in edgeSet.data:
		edge.image_walls(self)
	for room in rooms:
		room.image_ext(self)
	for edge in edgeSet.data:
		edge.image_empty(self,true)
	for room in rooms:
		var r1:Node = RoomScenes[room.type].instance()
		room.image_int(self)
		r1.position = map_to_world(Vector2(room.low.x+1,room.low.y+1))
		add_child(r1)
		roomChildren.append(r1)
		if r1.has_node("Enemies"):
			var temp = r1.get_node("Enemies")
			enemies.append(temp)
			r1.remove_child(temp)
		else:
			enemies.append(null)
		

# Returns the cneter of the room of type 0. This room has no enemies.
#	return - Location of spawn room.
func spawn_room() -> Vector2:
	var spawn = Vector2((rooms[0].xsize/2) + rooms[0].low.x,
						(rooms[0].ysize/2) + rooms[0].low.y)
	spawn *= 32 
	return spawn

# Returns the midpoint of some arbitrary room
# return - Vector2 spawn point
func arbitrary_room() -> Vector2:
	var t = int(rand_range(0,rooms.size()))
	# Set t to be a spawn room
	var spawn = Vector2((rooms[t].xsize/2)+rooms[t].low.x,
						(rooms[t].ysize/2)+rooms[t].low.y)
	spawn *= 32
	return spawn

# Finds room target is inside. Opens all hallways connected to room.
#	position - Position vector of target
func open_doors(position:Vector2):
	if lock:
		return
	get_parent().start_hall_timer()
	for pusher in pushers:
		pusher.purge()
		pusher.queue_free()
	pushers = []
	$Effects.clear()
	
	var currentRoomIndex = find_player_index(position)
	var currentRoom = rooms[currentRoomIndex]
	var d = []
	var dn = []
	for edge in edgeSet.data:
		edge.image_empty(self,false)
		if edge.contains(currentRoom):
			#edge.image_empty(self,false)
			d.append(edge.get_doors(currentRoom))
			dn.append(edge.get_door_normals(currentRoom))
	if d != null:
		for i in range(d.size()):
			var pf = PF.instance()
			pf.tmps = d[i]
			pf.dir = dn[i]
			pushers.append(pf)
			add_child(pf)
			pf.dfs_spread(dg)
			var pf2 = PF.instance()
			if dn[i].x != 0:
				pf2.tmps = Vector2(d[i].x,d[i].y+1)
			else:
				pf2.tmps = Vector2(d[i].x+1,d[i].y)
			pf2.dir = dn[i]
			pushers.append(pf2)
			add_child(pf2)
			pf2.dfs_spread(rg)
					
	for room in rooms:
		room.image_int(self)
		# for plat in platforms:
			# plat.image(self)

# Shuts every door in the edge set.
func close_doors():
	for edge in edgeSet.data:
		edge.image_empty(self,true)

# Determines where the player is and returns it as a Rect
#	position - Player's world position
#	return - Rect of where Player is, or null if player is in a hallway
func find_player(position:Vector2):
	var tpos = world_to_map(position)
	for room in rooms:
		if room.is_target_inside(tpos):
			return room
	return null

# Determine what room the player is in and return its index in
# the rooms array. 
#	position - Player's world position
#	return - Index of room in rooms array where player is or -1 if 
#			 in hallway.
func find_player_index(position:Vector2):
	var currentRoom:int = -1
	var tpos = world_to_map(position)
	for i in range(rooms.size()):
		if rooms[i].is_target_inside(tpos):
			return i
	return currentRoom

# Add the children of a room's Enemies node
# Only works if enemies have not already been killed 
# in that room.
#	roomIndex - Index to spawn enemies of.
func spawn_enemies(roomIndex:int):
	if roomIndex >= chest_rooms+1 && roomChildren[roomIndex].cleared != true:
		roomChildren[roomIndex].add_child(enemies[roomIndex])
		lock = true