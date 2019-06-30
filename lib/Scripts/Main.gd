extends Node
onready var Player = $Player
var rob = preload("res://Scenes/Robot.tscn")
var lootPoolWHITE = [preload("res://Scenes/TwoPercent.tscn"),preload("res://Scenes/Coffee.tscn"),
                     preload("res://Scenes/Grease.tscn")]
var lootPoolGREEN = [preload("res://Scenes/PainPills.tscn"),preload("res://Scenes/TowerShield.tscn"),
                     preload("res://Scenes/RollerBlades.tscn")]
var lootPoolBLUE = [preload("res://Scenes/MarineHelmet.tscn"),preload("res://Scenes/PhoneBook.tscn")]
var lootPoolPURPLE = [preload("res://Scenes/ElixirOfLife.tscn"),preload("res://Scenes/FullMetalJacket.tscn"),
                      preload("res://Scenes/Batteries.tscn")]
var lootPoolORANGE = [preload("res://Scenes/ChiliPepper.tscn"),preload("res://Scenes/BottleOfRage.tscn")]
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
#	damage - Amount of damage of the bullet
func on_Gun_shoot(bullet, direction, location, vel, damage):
	var child = bullet.instance()
	child.rotation = direction
	child.position = location
	child.speed = vel
	child.damage = damage
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
		Player.add_item(lootPoolWHITE[int(rand_range(0,lootPoolWHITE.size()))].instance())
	elif lootPool == Chest.GREEN:
		Player.add_item(lootPoolGREEN[int(rand_range(0,lootPoolGREEN.size()))].instance())
	elif lootPool == Chest.BLUE:
		Player.add_item(lootPoolBLUE[int(rand_range(0,lootPoolBLUE.size()))].instance())
	elif lootPool == Chest.PURPLE:
		Player.add_item(lootPoolPURPLE[int(rand_range(0,lootPoolPURPLE.size()))].instance())
	elif lootPool == Chest.ORANGE:
		Player.add_item(lootPoolORANGE[int(rand_range(0,lootPoolORANGE.size()))].instance())
	# Player.add_item(lootPoolPURPLE[int(rand_range(0,lootPoolPURPLE.size()))].instance())
	chest.disconnect("chest_entered",self,"_on_Chest_Entered")