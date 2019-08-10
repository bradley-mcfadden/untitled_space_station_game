extends ActiveItem


# Set the title of the Active Item
func _init():
	title = "Repulsor"
	cooldown = 75
	duration = 15
	is_ready = true


# Define the function to be called when active item is pressed
func active_effect():
	player.is_repelling = true


# Timer for invulnerability to end
func _on_Timer_timeout():
	player.get_node("CDTimer").start()
	player.hud.get_node("CDTimer").start()
	player.material = null
