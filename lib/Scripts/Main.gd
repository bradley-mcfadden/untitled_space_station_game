extends Node


onready var player:KinematicBody2D
const LOOT_POOL_WHITE = [preload("res://Items/TwoPercent.tscn"),preload("res://Items/Coffee.tscn"),
                     preload("res://Items/Grease.tscn"),preload("res://Items/TheChain.tscn"),
					 preload("res://Items/OldJersey.tscn"), preload("res://Items/BeyondMeat.tscn"),
					 preload("res://Items/Cookies.tscn"), preload("res://Items/Shells.tscn")]
const LOOT_POOL_GREEN = [preload("res://Items/PainPills.tscn"),preload("res://Items/TowerShield.tscn"),
                     preload("res://Items/RollerBlades.tscn"), preload("res://Items/ExtendedMagazine.tscn"),
					 preload("res://Items/Binoculars.tscn"),preload("res://Items/Dilopia.tscn")]
const LOOT_POOL_BLUE = [preload("res://Items/MarineHelmet.tscn"),preload("res://Items/PhoneBook.tscn"),
                    preload("res://Items/Gloves.tscn"), preload("res://Items/ItchyFinger.tscn")]
const LOOT_POOL_PURPLE = [preload("res://Items/ElixirOfLife.tscn"),preload("res://Items/FullMetalJacket.tscn"),
                      preload("res://Items/Batteries.tscn"),preload("res://Items/DrumClip.tscn"),
					  preload("res://Items/Deadeye.tscn"), preload("res://Items/SoyMilk.tscn")]
const LOOT_POOL_ORANGE = [preload("res://Items/ChiliPepper.tscn"),preload("res://Items/BottleOfRage.tscn"),
                      preload("res://Items/MysteryPowder.tscn"), preload("res://Items/Catalyst.tscn"),
					  preload("res://Items/AlmondMilk.tscn")]
const LOOT_POOL_ACTIVE = [preload("res://ActiveItems/IronSkin.tscn")]
const PICKUP = preload("res://Scenes/Pickup.tscn")
const COIN = preload("res://Scenes/Coin.tscn")


# Init
func _ready():
	player = $Player
	player.position = $RoomGenerator.spawn_room()


# Process physics of some world objects
#	delta - Time since last physics step	
func  _physics_process(delta):
	var coins:Array = $Coins.get_children()
	for coin in coins:
		coin.apply_force(player.pull(coin))


# Reset player position, enemies, etc
func new_game():
	PlayerVariables.reset()
	$RoomGenerator.generate_dungeon_2()
	player.start($RoomGenerator.spawn_room())
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
func on_Gun_shoot(bullet:Bullet, direction:float, location:Vector2, vel:float, damage:int):
	var child:Bullet = bullet.instance()
	child.rotation = direction
	child.position = location
	child.speed = vel
	child.damage = damage
	add_child(child)


# Determines the tiles adjacent to the player, above, below, and in front
func update_tiles():
	var tpos:Vector2 = $RoomGenerator.world_to_map($Player.position)
	var floor_tile:int = $RoomGenerator.get_cellv(Vector2(tpos.x, tpos.y + 1))
	if floor_tile == 7 || floor_tile == 8:
		$RoomGenerator.open_doors($Player.position)
	var front_tile:int = $RoomGenerator.get_cellv(Vector2(tpos.x + $Player.direction, tpos.y))
	if front_tile == 5 || front_tile == 6:
		$RoomGenerator.open_doors($Player.position)
	var ceiling_tile:int = $RoomGenerator.get_cellv(Vector2(tpos.x, tpos.y - 2))
	if ceiling_tile == 7 || ceiling_tile == 8:
		$RoomGenerator.open_doors($Player.position)


# Method so that children can start hall timer.
func start_hall_timer():
	$HallTimer.start()
	player.toggle_damping()


# Event handler for when hall time runs out.
# Closes all doors if player is in a room
func _on_HallTimer_timeout():
	var player_room:int = $RoomGenerator.find_player_index($Player.position)
	if player_room != -1:
		$HallTimer.stop()
		$RoomGenerator.close_doors()
		player.toggle_damping()
		$RoomGenerator.spawn_enemies(player_room)


# Event handler for a chest being opened.
#	pos - Position of chest.
#	loot_pool - Tier of the chest, determines what can drop from it.
func _on_Chest_Entered(chest,pos:Vector2, loot_pool:int):
	var drop:Pickup = PICKUP.instance()
	drop.global_position = chest.global_position
	var chestContents:Item
	if loot_pool == Chest.WHITE:
		chestContents = LOOT_POOL_WHITE[int(rand_range(0, LOOT_POOL_WHITE.size()))].instance()
	elif loot_pool == Chest.GREEN:
		chestContents = LOOT_POOL_GREEN[int(rand_range(0, LOOT_POOL_GREEN.size()))].instance()
	elif loot_pool == Chest.BLUE:
		chestContents = LOOT_POOL_BLUE[int(rand_range(0, LOOT_POOL_BLUE.size()))].instance()
	elif loot_pool == Chest.PURPLE:
		chestContents = LOOT_POOL_PURPLE[int(rand_range(0, LOOT_POOL_PURPLE.size()))].instance()
	elif loot_pool == Chest.ORANGE:
		chestContents = LOOT_POOL_ORANGE[int(rand_range(0, LOOT_POOL_ORANGE.size()))].instance()
	drop.set_item(chestContents)
	drop.connect("pickup", self, "_on_Pickup_Entered")
	call_deferred("add_child", drop)
	chest.disconnect("chest_entered", self, "_on_Chest_Entered")
	
	
# When a pickup is entered, add it to Player inventory or prompt to swap active items.
#	pickup - Reference to pickup scene
#	dropped_item - Item to place in inventory
func _on_Pickup_Entered(pickup:Pickup, dropped_item:Item):
	if pickup.cost == 0:
		player.add_item(dropped_item)
		player.HUD.fading_message("Picked up '" + dropped_item.title + "'.")
		pickup.queue_free()
	else:
		player.HUD.set_message_text("Purchase '" + dropped_item.title + "' for "+str(pickup.cost) + "?")
		player.potentialPurchase = pickup


# Clear the text in the message label when a Pickup is exited
func _on_Pickup_Exited():
	player.HUD.set_message_text("")


# Handles signal and adds coins to the scene
#	location - Global position to place coins
#	num_coins - Number of coins to add
func _on_Drop_Coins(location:Vector2, num_coins:int):
	for i in range(num_coins):
		var c:Coin = COIN.instance()
		c.global_position = location
		$Coins.add_child(c)