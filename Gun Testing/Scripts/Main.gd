extends Node

var rob = preload("res://Scenes/Robot.tscn")
onready var Robot = $Robot

# Init
func _ready():
	$Player.position = $RoomGenerator.arbitrary_room()
	
# Reset player position, enemies, etc
func new_game():
	$Player.start()
	$Player/HUD/DeathLabel.visible = false
	$Player/HUD/RestartButton.visible = false
	# spawn_robot()
	
# Called when character dies
func game_over():
	pass

# Event handler when Gun is fired
#	bullet - Bullet to place on screen
#	direction - Rotation of bullet
#	location - Location to spawn bullet
#	vel - Movement speed of bullet 
func on_Gun_shoot(bullet, direction, location, vel):
	var child = bullet.instance()
	child.rotation = direction
	child.position = location
	child.speed = vel
	add_child(child)

# CURRENTLY DEPRECATED
# Spawns a robot
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

# Determines the tiles adjacent to the player, above, below, and in front
func update_tiles():
	var tpos = $RoomGenerator.world_to_map($Player.position)
	var floor_tile = $RoomGenerator.get_cellv(Vector2(tpos.x, tpos.y + 1))
	if floor_tile == 7 || floor_tile == 8:
		$RoomGenerator.open_doors($Player.position)
		# print(floor_tile)
	var front_tile = $RoomGenerator.get_cellv(Vector2(tpos.x+$Player.direction, tpos.y))
	if front_tile == 5 || front_tile == 6:
		$RoomGenerator.open_doors($Player.position)
		# print(front_tile)
	var ceiling_tile = $RoomGenerator.get_cellv(Vector2(tpos.x, tpos.y-2))
	if ceiling_tile == 7 || ceiling_tile == 8:
		$RoomGenerator.open_doors($Player.position)
		# print(ceiling_tile)

func _physics_process(delta):
	pass