extends Node
#var Dungeon = preload("res://Scenes/TileMap.gd")
#var tilemap
func _ready():
	pass
	
func new_game():
	$Player/HUD/DeathLabel.visible = false
	$Player/HUD/RestartButton.visible = false
	$Player.start()
	
func game_over():
	pass

func on_Gun_shoot(bullet, direction, location, vel):
	var child = bullet.instance()
	child.rotation = direction
	child.position = location
	child.speed = vel
	add_child(child)
