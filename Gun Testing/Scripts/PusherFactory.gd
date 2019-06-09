# A PusherFactory is a source of pushers, it is meant to be placed
# in a door and spread through a hallways as a means of travel.
extends Node
class_name PusherFactory

onready var tm:TileMap
onready var ef:TileMap
onready var tmps:Vector2
onready var pushers = []
onready var flowStack = []
onready var dir:Vector2
var PSHR = load("res://Scenes/Pusher.tscn")
onready var hp:int
onready var vp:int
onready var dg:int
onready var newPos:Vector2
onready var visited = UnsortedSet.new()
onready var vDir = []
# Init
func _ready():
	tm = get_parent()
	ef = tm.Effects
	hp = ef.tile_set.find_tile_by_name("HorizontalPull")
	vp = ef.tile_set.find_tile_by_name("VerticalPull")
	
# Depth first search that spreads down a certain tile
#	brick - Tile to spread down
func dfs_spread(brick:int,debug=false):
	dg = brick
	vDir.append(dir)
	dfs_flood(tmps,dir)
	# print(visited.data.size()," ",vDir.size())
	for i in range(visited.data.size()):
		var pPos = tm.map_to_world(visited.data[i])
		var push = PSHR.instance()
		push.create(pPos,vDir[i])
		pushers.append(push)
		add_child(push,true)
		if debug:
			if vDir[i].x == 1:
				ef.set_cellv(visited.data[i],4)
			elif vDir[i].x == -1:
				ef.set_cellv(visited.data[i],6)
			elif vDir[i].y == -1:
				ef.set_cellv(visited.data[i],3)
			elif vDir[i].y == 1:
				ef.set_cellv(visited.data[i],5)
		else:
			if vDir[i].x != 0:
				ef.set_cellv(visited.data[i],hp)
			else:
				ef.set_cellv(visited.data[i],vp)

# Recursive flood function that spreads down a tile
#	pos - Position of current tile
#	dir - Direction of current tile
func dfs_flood(pos:Vector2,dir:Vector2):
	visited.add(pos)
	var normal = Vector2(dir.y,dir.x)
	for i in range(1,3):
		if tm.get_cellv(pos+(dir*i)) == dg:
			if visited.contains(pos+(dir*i)):
				return
			else:
				vDir.append(dir)
				dfs_flood(pos+(dir*i),dir)
		if tm.get_cellv(pos+(normal*i)) == dg:
			if visited.contains(pos+(normal*i)):
				return
			else:
				vDir.append(normal)
				dfs_flood(pos+(normal*i),normal)
		if tm.get_cellv(pos-(normal*i)) == dg:
			if visited.contains(pos-(normal*i)):
				return
			else:
				vDir.append(-normal)
				dfs_flood(pos-(normal*i),-normal)

# Cleanup function that destroys all children and this node
func purge():
	for pusher in pushers:
		pusher.queue_free()
	queue_free()