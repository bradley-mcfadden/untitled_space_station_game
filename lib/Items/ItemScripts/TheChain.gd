extends Item

# Init 
func _init():
	image = texture
	title = "The Chain"

# Make player magazine size larger, fire gun faster
#	p - Player
func effect(p):
	PlayerVariables.clipMultiplier *= 1.2
	var cGun:Gun 
	for child in p.get_children():
		if child is Gun:
			cGun = child
	cGun.RateOfFireTimer.wait_time *= 0.90
	
	PlayerVariables.fireRateMultiplier *= 0.90
