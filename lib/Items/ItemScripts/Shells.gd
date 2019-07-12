extends Item

# Init
func _init():
	image = texture
	title = ""	

# Add durability to play's current gun
#	p - Target of effect
func effect(p):
	var cGun:Gun 
	for child in p.get_children():
		if child is Gun:
			cGun = child
	cGun.currentDurability += cGun.clipSize * 2