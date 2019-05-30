extends TileMap

var UnsortedSet = load("res://Scripts/UnsortedSet.gd")
var Point = load("res://Scripts/Point.gd")
var Edge = load("res://Scripts/Edge.gd")
var Rect = load("res://Scripts/Rect.gd")

export var cell_countw:int
export var cell_counth:int
onready var rooms = []
onready var edgeSet = UnsortedSet.new()
onready var platforms = []
const ROOM_ATTEMPTS = 20
const MIN_WIDTH = 15
const MIN_HEIGHT = 15
const MAX_WIDTH = 45
const MAX_HEIGHT = 20

# Init
func _ready():
	randomize()
	generate_rooms()
	connect_rooms()
	generate_platforms()
	display()

# Generate non-overlapping rooms
func generate_rooms():
	var w
	var h 
	var p
	# Generate rooms along grid
	for i in range(ROOM_ATTEMPTS):
    	w = int(rand_range(MIN_WIDTH,MAX_WIDTH))
    	h = int(rand_range(MIN_HEIGHT,MAX_HEIGHT))
    	p =  Point.new(int(rand_range(0,cell_countw-w)), 
				 int(rand_range(0,cell_counth-h)))
    	rooms.append(Rect.new(w,h,p))
	# Mark rooms that overlap with rooms not marked as overlapping
	for i in range(rooms.size()):
		var current = rooms[i]
		for j in range(rooms.size()):
			if i == j:
				continue
			if !rooms[j].overlap and current.is_inside(rooms[j]):
				rooms[i].overlap = true
				current.overlap = true
				break
				
	# Remove rooms from the set that are marked as overlapping
	# Goes in reverse order to avoid screwing up things
	var rs = rooms.size()
	for i in range(1,rs+1):
		if rooms[rs-i].overlap:
			rooms.remove(rs-i)

# Generate a minimal spanning tree of the generate rooms
func connect_rooms():
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
				weightMatrix[i][j] = r.dist(rooms[j])
				
	var adjMatrix = []
	for i in range(rooms.size()):
		adjMatrix.append([])
		for j in range(rooms.size()):
			adjMatrix[i].append(0)

	for i in range(rooms.size()-1):
		while true:
			var minPos = kruskal(adjMatrix,weightMatrix)
			adjMatrix[minPos[0]][minPos[1]] = 1
			adjMatrix[minPos[1]][minPos[0]] = 1
			if !has_cycle(adjMatrix):
				var e = Edge.new(rooms[minPos[0]], rooms[minPos[1]])
				edgeSet.add(e)
				break
			adjMatrix[minPos[0]][minPos[1]] = 0
			adjMatrix[minPos[1]][minPos[0]] = 0
			weightMatrix[minPos[0]][minPos[1]] = 1000000
			weightMatrix[minPos[1]][minPos[0]] = 1000000
	
#	for i in range(rooms.size()/4):
#		var minPos = kruskal(adjMatrix,weightMatrix)
#		var e = Edge.new(rooms[minPos[0]], rooms[minPos[1]])
#		while !edgeSet.add(e):
#			minPos = kruskal(adjMatrix,weightMatrix)
#			e = Edge.new(rooms[minPos[0]], rooms[minPos[1]])
#		adjMatrix[minPos[0]][minPos[1]] = 0
#		adjMatrix[minPos[1]][minPos[0]] = 0
#		weightMatrix[minPos[0]][minPos[1]] = 1000000
#		weightMatrix[minPos[1]][minPos[0]] = 1000000
#
					
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

# Accepts and adjacency matrix and a weighted adjacency matrix.
# Determines minimal edge not already in the adjacency matrix.
#	adj - Adjacency matrix
#	weight - Matrix of all possible edges with distances
func kruskal(adj:Array, weight:Array) -> Array:
	var minI = 0
	var minJ = 0
	for i in range(weight.size()):
		for j in range(i,weight[i].size()):
			if adj[i][j] == 0:
				if weight[i][j] < weight[minI][minJ]:
					minI = i
					minJ = j
	var mp = []
	mp.append(minI)
	mp.append(minJ)	
	return mp
	
# Displays the image of each room and edge on the TileMap
func display():
	for edge in edgeSet.data:
		edge.image_walls(self)
	for room in rooms:
		room.image_ext(self)
	for edge in edgeSet.data:
		edge.image_empty(self,true)
	for room in rooms:
		room.image_int(self)
	for plat in platforms:
		plat.image(self)

# Returns the midpoint of some arbitrary room
# return - Vector2 spawn point
func arbitrary_room() -> Vector2:
	var t = int(rand_range(0,rooms.size()))
	var spawn = Vector2((rooms[t].xsize/2)+rooms[t].low.x,
						(rooms[t].ysize/2)+rooms[t].low.y)
	spawn *= 32
	return spawn
	
# Generate platforms in each room, so that the room can be traversed
func generate_platforms():
	randomize()
	var w 
	var h = 0
	var p
	for room in rooms:
		var rand = room.ysize/4
		var split = room.ysize/rand
		for i in range(1,rand):
			w = int(rand_range(room.xsize/3,room.xsize-4))
			if i < rand-1:
				p = Point.new(int(rand_range(room.low.x+2, room.high.x-w-2)),
					  1+room.low.y+(i*split))
			else:
				p = Point.new(int(rand_range(room.low.x+2, room.high.x-w)),
					  1+room.low.y+i*split)
			var plat = Rect.new(w,h,p)
			platforms.append(plat)

# Finds room target is inside. Opens all hallways connected to room.
#	position - Position vector of target
func open_doors(position:Vector2):
	var currentRoom
	for room in rooms:
		if room.is_target_inside(position):
			currentRoom = room
			break
	var edgeList
	for edge in edgeSet:
		if edge.contains(currentRoom):
			edge.image_empty(self,false)