extends Button


# Makes menus visible when button clicked
func _on_Control_button_up():
	$Options.popup()


# Adds activeitem to inventory after player clicks it
#	index - Index of item to add
func _on_ActiveItems_index_pressed(index:int):
	var player:Player = get_parent().get_parent()
	player.add_active_item(GlobalVariables.LOOT_POOL_ACTIVE[index].instance())


# Adds item to player's inventory after being added
#	index - Item to add
func _on_Items_index_pressed(index:int):
	var player:Player = get_parent().get_parent()
	player.add_item(GlobalVariables.ALL_ITEMS[index].instance())


# Adds gun to player inventory after being clicked
#	index of gun to add
func _on_Guns_index_pressed(index:int):
	var player:Player = get_parent().get_parent()
	player.gun_inventory.add(GlobalVariables.GUNREF[index].instance())


# Handler for when list item is clicked
#	index - List item that was clicked
func _on_Options_index_pressed(index:int):
	print(index)
	if index == 0:
		pass
	elif index == 1:
		pass
	elif index == 2:
		pass
	elif index == 3:
		var main:Node = get_parent().get_parent().get_parent()
		var player:Player = main.player
		main.world.kill_enemies(main.world.find_player_index(player.position))
		
