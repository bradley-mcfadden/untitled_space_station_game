extends ActiveItem


# Set the title of the Active Item
func _init():
	title = "Iron Skin"
	cooldown = 20
	duration = 10
	is_ready = true


# Define the function to be called when active item is pressed
func active_effect():
	player.has_iron_skin = true
	player.movespeed *= 0.9
	player.speed_cap *= 0.8
	player.material = load("res://Shaders/Grayscale.tres")


# Timer for invulnerability to end
func _on_Timer_timeout():
	player.get_node("CDTimer").start()
	player.hud.get_node("CDTimer").start()
	player.material = null
	player.has_iron_skin = false
	player.movespeed *= 1.0 / 0.9
	player.speed_cap *= 1.0 / 0.9