extends Item

# Init 
func _init():
	image = texture
	title = "Phone Book"

# Give an overshield effect
#	p - Player target
func effect(p):
	p.health += 70
	p.maxHealth += 20
	p.HUD.health_update(p.health,20)