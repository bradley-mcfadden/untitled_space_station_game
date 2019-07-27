extends Item


# Init
func _init():
	image = texture
	title = "Itchy Finger"	


# Increase rate of fire of player
#	player - Player to apply effect to
func effect(player:KinematicBody2D):
	var c_gun:Gun 
	for child in player.get_children():
		if child is Gun:
			c_gun = child
	c_gun.rate_of_fire_timer.wait_time *= 0.7
	PlayerVariables.fire_rate_multiplier *= 0.7


