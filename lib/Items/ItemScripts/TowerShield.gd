extends Item

# Init 
func _init():
	image = texture
	title = "Tower Shield"

# Give an overshield effect
#	p - Player target
func effect(p):
	p.health += 70
	p.HUD.health_update(p.health)