extends Item

func _ready():
	image = texture
	title = ""
		
func effect(p):
	PlayerVariables.reloadMultiplier *= 0.90
	var cGun:Gun 
	for child in p.get_children():
		if child is Gun:
			cGun = child
	cGun.ReloadTimer.wait_time *= 0.90
	
	PlayerVariables.fireRateMultiplier *= 0.85
	cGun.RateOfFireTimer.wait_time *= 0.85