# A PusherFactory is a source of pushers, it is meant to be placed
# in a door and spread through a hallways as a means of travel.
extends Node
class_name PusherFactory


const PUSHER = preload("res://Scenes/Pusher.tscn")
onready var tilemap:TileMap
onready var effects_tilemap:TileMap
onready var tilemap_position:Vector2
onready var pushers:Array = []
onready var direction:Vector2
onready var horizontal_pull_tile:int
onready var vertical_pull_tile:int
onready var searchable_tile:int
onready var visited_tiles:UnsortedSet = UnsortedSet.new()
onready var visited_direction:Array = []


# Init
func _ready():
	tilemap = get_parent()
	effects_tilemap = tilemap.Effects
	horizontal_pull_tile = effects_tilemap.tile_set.find_tile_by_name("HorizontalPull")
	vertical_pull_tile = effects_tilemap.tile_set.find_tile_by_name("VerticalPull")


# Depth first search that spreads down a certain tile
#	brick - Tile to spread down
func dfs_spread(brick:int,debug=false):
	searchable_tile = brick
	visited_direction.append(direction)
	dfs_flood(tilemap_position,direction)
	for i in range(visited_tiles.data.size()):
		var potential_position:Vector2 = tilemap.map_to_world(visited_tiles.data[i])
		var pusher:Pusher = PUSHER.instance()
		pusher.create(potential_position,visited_direction[i])
		pushers.append(pusher)
		add_child(pusher,true)
		if debug == true:
			if visited_direction[i].x == 1:
				effects_tilemap.set_cellv(visited_tiles.data[i],4)
			elif visited_direction[i].x == -1:
				effects_tilemap.set_cellv(visited_tiles.data[i],6)
			elif visited_direction[i].y == -1:
				effects_tilemap.set_cellv(visited_tiles.data[i],3)
			elif visited_direction[i].y == 1:
				effects_tilemap.set_cellv(visited_tiles.data[i],5)
		else:
			if visited_direction[i].x != 0:
				effects_tilemap.set_cellv(visited_tiles.data[i],horizontal_pull_tile)
			else:
				effects_tilemap.set_cellv(visited_tiles.data[i],vertical_pull_tile)


# Recursive flood function that spreads down a tile
#	pos - Position of current tile
#	direction - Direction of current tile
func dfs_flood(pos:Vector2,direction:Vector2):
	visited_tiles.add(pos)
	var normal:Vector2 = Vector2(direction.y,direction.x)
	for i in range(1,3):
		if tilemap.get_cellv(pos+(direction*i)) == searchable_tile:
			if visited_tiles.contains(pos+(direction*i)):
				pass
			else:
				visited_direction.append(direction)
				dfs_flood(pos+(direction*i),direction)
		if tilemap.get_cellv(pos+(normal*i)) == searchable_tile:
			if visited_tiles.contains(pos+(normal*i)):
				pass
			else:
				visited_direction.append(normal)
				dfs_flood(pos+(normal*i),normal)
		if tilemap.get_cellv(pos-(normal*i)) == searchable_tile:
			if visited_tiles.contains(pos-(normal*i)):
				pass
			else:
				visited_direction.append(-normal)
				dfs_flood(pos-(normal*i),-normal)


# Cleanup function that destroys all children and this node
func purge():
	for pusher in pushers:
		pusher.queue_free()
	queue_free()