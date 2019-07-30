extends Item


# Init
func _init():
	image = texture
	title = "Gloves"


# Decreases time for player to reload and increases
# rate of fire.
#	player - Player to put effect on.
func effect(player:KinematicBody2D):
	PlayerVariables.reload_multiplier *= 0.90
	var c_gun:Gun 
	for child in player.get_children():
		if child is Gun:
			c_gun = child
	c_gun.reload_timer.wait_time *= 0.90
	
	PlayerVariables.fire_rate_multiplier *= 0.85
	c_gun.rate_of_fire_timer.wait_time *= 0.85