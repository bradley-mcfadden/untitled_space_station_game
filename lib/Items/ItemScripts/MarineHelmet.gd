extends Item

# Init 
func _init():
	image = texture
	title = "Marine Helmet"

# Give an overshield effect
#	p - Player target
func effect(p):
	p.health += 50
	p.HUD.health_update(p.health)