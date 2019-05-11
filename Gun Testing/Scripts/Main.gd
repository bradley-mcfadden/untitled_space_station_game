extends Node
var Dungeon = preload("res://Scenes/TileMap.gd")
var tilemap
func _ready():
	#$TileMap.generate(0,0,50,50,3)
#	var tile_map = create_2d_array(100,100,0)
	var DARK_TILE = $TileMap.tile_set.find_tile_by_name("DarkGrayBrick")
	print(DARK_TILE)
#	for i in range(tile_map.size()):
#		for j in range(tile_map[i].size()):
#			if tile_map[i][j] == 0:
#				$TileMap.set_cell(i-10,j-10,DARK_TILE)
#	$TileMap.update()
#	pass

func on_Gun_shoot(bullet, direction, location, vel):
	var child = bullet.instance()
	child.rotation = direction
	child.position = location
	child.speed = vel
	add_child(child)
	
func _on_Shotgun_shoot(bul, dir, pos, speed):
	pass # Replace with function body.
