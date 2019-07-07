extends Item

# Init
func _init():
	image = texture
	title = "Pain Pills"
	
# Increase max health + overshield
#	p - Player reference	
func effect(p):
	p.maxHealth += 20
	p.HUD.health_update(p.maxHealth,20)
	p.health += 50
	p.HUD.health_update(p.health)
