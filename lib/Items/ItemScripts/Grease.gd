extends Item

# Init
func _ready():
	image = texture
	title = ""	
	
# Makes player reload faster
#	p - Player
func effect(p):
	PlayerVariables.reloadMultiplier *= 0.70
	var cGun:Gun 
	for child in p.get_children():
		if child is Gun:
			cGun = child
	cGun.ReloadTimer.wait_time *= 0.70
