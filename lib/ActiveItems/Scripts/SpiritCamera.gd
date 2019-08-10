extends ActiveItem


# Set the title of the Active Item
func _init():
	title = "Spirit Camera"
	cooldown = 60
	duration = 1
	is_ready = true


# Define the function to be called when active item is pressed
func active_effect():
	var main:Node2D = player.get_parent()
	var room_revealed:int = randi() % main.world.chest_rooms + 2
	main.world.neighbour_visited_rooms.add(main.world.room_instances[room_revealed])
	player.set_material(load("res://Shaders/OscillatingPurple.tres"))


# Timer for invulnerability to end
func _on_Timer_timeout():
	player.get_node("CDTimer").start()
	player.hud.get_node("CDTimer").start()
	player.material = null