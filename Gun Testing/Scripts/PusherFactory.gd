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
# Init
func _ready():
	tm = get_parent()
	ef = tm.Effects
	hp = ef.tile_set.find_tile_by_name("HorizontalPull")
	vp = ef.tile_set.find_tile_by_name("VerticalPull")
	dg = tm.tile_set.find_tile_by_name("DarkPurpleBrick")
	
# Starts pusher factory
func spread():
	newPos = tmps
	while flood():
		newPos = tm.world_to_map(pushers[pushers.size()-1].position)
	
# Spreads pushers down a hallways
# Will also image tiles and add pushers to array
#	return - Was this successful?
func flood() -> bool:
	var success = 0
	if pushers.size() == 0:
		if add_pusher(dir) > 0:
			var pPos = tm.map_to_world(newPos+dir)
			var push = PSHR.instance()
			push.create(pPos,dir)
			pushers.append(push)
			add_child(push,true)
			success += 1
		var normal = Vector2(dir.y,dir.x)
		if add_pusher(normal) > 0:
			var pPos = tm.map_to_world(newPos+dir)
			var push = PSHR.instance()
			push.create(pPos,normal)
			pushers.append(push)
			add_child(push,true)
			success += 1
		normal *= -1
		if add_pusher(normal) > 0:
			var pPos = tm.map_to_world(newPos+dir)
			var push = PSHR.instance()
			push.create(pPos,normal)
			pushers.append(push)
			add_child(push,true)
			success += 1
		if success > 0:
			dir = pushers[pushers.size()-1].dir
	else:
		for i in range(0, pushers.size()):
			newPos = tm.world_to_map(pushers[i].position)
			if add_pusher(dir) > 0:
				var pPos = tm.map_to_world(newPos+dir)
				var push = PSHR.instance()
				push.create(pPos,dir)
				pushers.append(push)
				add_child(push,true)
				success += 1
			var normal = Vector2(dir.y,dir.x)
			if add_pusher(normal) > 0:
				var pPos = tm.map_to_world(newPos+dir)
				var push = PSHR.instance()
				push.create(pPos,normal)
				pushers.append(push)
				add_child(push,true)
				success += 1
			normal *= -1
			if add_pusher(normal) > 0:
				var pPos = tm.map_to_world(newPos+dir)
				var push = PSHR.instance()
				push.create(pPos,normal)
				pushers.append(push)
				add_child(push,true)
				success += 1
			if success > 0:
				dir = pushers[pushers.size()-1].dir
				break
	return success > 0
	
# Adds pusher to TileMap and returns 1 if it can be added
#	dir - Direction of pusher relative to newPos
#	return - 1 or 0 for success or failure
func add_pusher(dir:Vector2)->int:
	if ef.get_cellv(newPos+dir) < 0 and tm.get_cellv(newPos+dir) == dg:
		if dir.x != 0:
			ef.set_cellv(newPos+dir,hp)
		else:
			ef.set_cellv(newPos+dir,vp)
		return 1
	return 0
	
# Cleanup function that destroys all children and this node
func purge():
	for pusher in pushers:
		pusher.queue_free()
	queue_free()