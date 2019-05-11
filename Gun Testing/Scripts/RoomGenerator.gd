extends TileMap

var UnsortedSet = load("res://Scripts/UnsortedSet.gd")
var Point = load("res://Scripts/Point.gd")
var Edge = load("res://Scripts/Edge.gd")
var Rect = load("res://Scripts/Rect.gd")

export var cell_countw:int
export var cell_counth:int
onready var rooms:Array
onready var edge_set = UnsortedSet.new()

func _ready():
	pass # Replace with function body.

# Generate non-overlapping rooms and add them to the TileMap
func generate_rooms():
	pass

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