extends Item

# Init
func _init():
	image = texture
	title = "Mystery Powder"	
	
# Increase rate of fire of player
#	p - Player to apply effect to
func effect(p):
	var cGun:Gun 
	for child in p.get_children():
		if child is Gun:
			cGun = child
	cGun.RateOfFireTimer.wait_time *= 0.8
	PlayerVariables.fireRateMultiplier *= 0.8
	PlayerVariables.damageMultiplier *= 1.2