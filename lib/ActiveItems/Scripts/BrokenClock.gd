extends ActiveItem


# Set the title of the Active Item
func _init():
	title = "Broken Clock"
	cooldown = 2
	duration = 6.5
	is_ready = true


# Define the function to be called when active item is pressed
func active_effect():
	player.get_parent().set_material(load("res://Shaders/NormalToNegative.tres"))
	player.get_parent().get_material().set_shader_param("starting_time", OS.get_ticks_msec() / 1000.0)
	player.get_parent().za_warudo()


# Timer for invulnerability to end
func _on_Timer_timeout():
	player.get_node("CDTimer").start()
	player.hud.get_node("CDTimer").start()
	player.get_parent().set_material(load("res://Shaders/NegativeToNormal.tres"))
	player.get_parent().get_material().set_shader_param("starting_time", OS.get_ticks_msec() / 1000.0)
	player.get_parent().za_warudo(false)