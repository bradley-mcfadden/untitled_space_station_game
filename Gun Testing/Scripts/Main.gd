extends Node
#var Dungeon = preload("res://Scenes/TileMap.gd")
#var tilemap
var rob = preload("res://Scenes/Robot.tscn")
onready var Robot = $Robot
func _ready():
	pass
	
func new_game():
	$Player.start()
	$Player/HUD/DeathLabel.visible = false
	$Player/HUD/RestartButton.visible = false
	spawn_robot()
	
func game_over():
	pass

func on_Gun_shoot(bullet, direction, location, vel):
	var child = bullet.instance()
	child.rotation = direction
	child.position = location
	child.speed = vel
	add_child(child)

func spawn_robot():
	randomize()
	var w = rand_range(-400,400)
	var h = rand_range(-1,1)
	var i
	if h > 0:
		i = 0
	else:
		i = 150
	Robot.queue_free()
	Robot = rob.instance()
	Robot.position = Vector2(w,i)
	add_child(Robot)