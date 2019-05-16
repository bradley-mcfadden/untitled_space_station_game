extends Node
#var Dungeon = preload("res://Scenes/TileMap.gd")
var tilemap
func _ready():
	pass

func on_Gun_shoot(bullet, direction, location, vel):
	var child = bullet.instance()
	child.rotation = direction
	child.position = location
	child.speed = vel
	add_child(child)
	
func _on_Shotgun_shoot(bul, dir, pos, speed):
	pass # Replace with function body.
