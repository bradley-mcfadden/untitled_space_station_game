extends Item

# Init
func _init():
	image = texture
	title = "Two Percent"
	
# Increment max health and health of Player
#	p - Player reference	
func effect(p):
	p.maxHealth += 20
	p.HUD.health_update(p.maxHealth,20)
	p.health += 20
	p.HUD.health_update(p.health)