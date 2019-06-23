extends Node
onready var Player = $Player
var rob = preload("res://Scenes/Robot.tscn")
var lootPoolWHITE = [preload("res://Scenes/TwoPercent.tscn")]

# Init
func _ready():
	Player.position = $RoomGenerator.spawn_room()
	
# Reset player position, enemies, etc
func new_game():
	$RoomGenerator.generate_dungeon_2()
	Player.start($RoomGenerator.spawn_room())
	$Player/HUD/DeathLabel.visible = false
	$Player/HUD/RestartButton.visible = false
	
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

# Method so that children can start hall timer.
func start_hall_timer():
	$HallTimer.start()
	Player.toggle_damping()
	
# Event handler for when hall time runs out.
# Closes all doors if player is in a room
func _on_HallTimer_timeout():
	var playerRoom = $RoomGenerator.find_player_index($Player.position)
	if playerRoom != -1:
		$HallTimer.stop()
		$RoomGenerator.close_doors()
		Player.toggle_damping()
		$RoomGenerator.spawn_enemies(playerRoom)

# Event handler for a chest being opened.
#	pos - Position of chest.
#	lootPool - Tier of the chest, determines what can drop from it.
func _on_Chest_Entered(chest:Chest,pos:Vector2,lootPool:int):
	if lootPool == Chest.WHITE:
		pass
	elif lootPool == Chest.GREEN:
		pass
	elif lootPool == Chest.BLUE:
		pass
	elif lootPool == Chest.PURPLE:
		pass
	elif lootPool == Chest.ORANGE:
		pass
	Player.add_item(lootPoolWHITE[0].instance())
	chest.disconnect("chest_entered",self,"_on_Chest_Entered")