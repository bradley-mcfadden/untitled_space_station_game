extends ActiveItem


# Set the title of the Active Item
func _init():
	title = "Broken Clock"
	cooldown = 40
	duration = 5
	is_ready = true


# Define the function to be called when active item is pressed
func active_effect():
	player.get_parent().material = load("res://Shaders/NormalToNegative.tres")
	player.get_parent().za_warudo()


# Timer for invulnerability to end
func _on_Timer_timeout():
	player.get_node("CDTimer").start()
	player.hud.get_node("CDTimer").start()
	player.get_parent().material = null
	player.get_parent().za_warudo(false)