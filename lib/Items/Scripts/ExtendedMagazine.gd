extends Item


# Init
func _init():
	image = texture
	title = "Extended Magazine"	


# Make magazine bigger for Player
#	player - Player to apply effect to
func effect(player:KinematicBody2D):
	PlayerVariables.clip_size_multiplier *= 1.5
	PlayerVariables.fire_rate_multiplier *= 1.1
	var c_gun:Gun 
	for child in player.get_children():
		if child is Gun:
			c_gun = child
	c_gun.rate_of_fire_timer.wait_time *= 1.1