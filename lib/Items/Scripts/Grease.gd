extends Item


# Init
func _init():
	image = texture
	title = "Grease"	


# Makes player reload faster
#	player - Player
func effect(player:KinematicBody2D):
	PlayerVariables.reload_multiplier *= 0.70
	var c_gun:Gun 
	for child in player.get_children():
		if child is Gun:
			c_gun = child
	c_gun.reload_timer.wait_time *= 0.70
