extends Item

# Init
func _init():
	image = texture
	title = "Cookies"	
	
# Health 30% of player health
#	p - Player to heal
func effect(p):
	p.health += int(p.health*0.15)
	if p.health > p.maxHealth:
		p.health = p.maxHealth
	p.HUD.health_update(p.health,0)

