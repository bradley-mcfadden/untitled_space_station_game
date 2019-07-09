extends Item

# Init
func _init():
	image = texture
	title = "Beyond Meat"	
	
# Health 30% of player health
#	p - Player to heal
func effect(p):
	p.health += int(p.health*0.3)
	if p.health > p.maxHealth:
		p.health = p.maxHealth
	p.HUD.health_update(p.health,0)


