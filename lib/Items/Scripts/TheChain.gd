extends Item


# Init 
func _init():
	image = texture
	title = "The Chain"


# Make player magazine size larger, fire gun faster
#	player - Player
func effect(player:KinematicBody2D):
	PlayerVariables.clip_size_multiplier *= 1.2
	var c_gun:Gun 
	for child in player.get_children():
		if child is Gun:
			c_gun = child
	c_gun.rate_of_fire_timer.wait_time *= 0.90
	PlayerVariables.fire_rate_multiplier *= 0.90