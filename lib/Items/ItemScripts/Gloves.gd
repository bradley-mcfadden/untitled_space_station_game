extends Item

# Init
func _init():
	image = texture
	title = "Gloves"

# Decreases time for player to reload and increases
# rate of fire.
#	p - Player to put effect on.
func effect(p):
	PlayerVariables.reloadMultiplier *= 0.90
	var cGun:Gun 
	for child in p.get_children():
		if child is Gun:
			cGun = child
	cGun.ReloadTimer.wait_time *= 0.90
	
	PlayerVariables.fireRateMultiplier *= 0.85
	cGun.RateOfFireTimer.wait_time *= 0.85