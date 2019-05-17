extends TileMap

var UnsortedSet = load("res://Scripts/UnsortedSet.gd")
var Point = load("res://Scripts/Point.gd")
var Edge = load("res://Scripts/Edge.gd")
var Rect = load("res://Scripts/Rect.gd")

export var cell_countw:int
export var cell_counth:int
onready var rooms = []
onready var edgeSet = UnsortedSet.new()
const ROOM_ATTEMPTS = 1000
const MIN_WIDTH = 5
const MIN_HEIGHT = 5
const MAX_WIDTH = 15
const MAX_HEIGHT = 10

func _ready():
	pass # Replace with function body.

# Generate non-overlapping rooms and add them to the TileMap
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
				break
	# Remove rooms from the set that are marked as overlapping
	# Goes in reverse order to avoid screwing up things
	for i in range(1,rooms.size()+1):
		if rooms[-i].overlap:
			rooms.remove(-i)
		

# Generate a minimal spanning tree of the generate rooms
func connect_rooms():
	pass
	
# Checks an adjacency matrix for existence of cycles.
#	matrix - Adjacency matrix to check
#	return - Does the matrix have a cycle? 
func has_cycle():
	pass

# Performs a depth-first search upon an adjacency matrix.
#	matrix - Adjacency matrix to search
#	return - Found a back edge?	
func dfs():
	pass

# Accepts and adjacency matrix and a weighted adjacency matrix.
# Determines minimal edge not already in the adjacency matrix.
#	adjMatrix - Adjacency matrix
#	costMatrix - Matrix of all possible edges with distances
func kruskal():
	pass

# Accepts an array and returns an array of vectors with 
# first dimension original value, sorted by ascending order,
# and second dimension the original index.
# arr - Array to operate on
# return - 2D array sorted in ascending order, with original 
#		   indices marked.	
func kth_min_array():
	pass