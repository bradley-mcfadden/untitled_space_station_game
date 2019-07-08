extends Item

# Init
func _init():
	image = texture
	title = "Extended Magazine"	

# Make magazine bigger for Player
#	p - Player to apply effect to
func effect(p):
	PlayerVariables.clipMultiplier *= 1.5
	PlayerVariables.fireRateMultiplier *= 1.1
	var cGun:Gun 
	for child in p.get_children():
		if child is Gun:
			cGun = child
	cGun.RateOfFireTimer.wait_time *= 1.1


