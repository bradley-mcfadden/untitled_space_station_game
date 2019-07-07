extends Item

# Init
func _init():
	image = texture
	title = "Elixir of Life"
	
# Increase max health and restore life to full
#	p - Player reference	
func effect(p):
	p.maxHealth += 40
	p.HUD.health_update(p.maxHealth,20)
	p.health = p.maxHealth
	p.HUD.health_update(p.health)
