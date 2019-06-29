extends Item
# Init
func _ready():
	image = texture
	title = "Pain Pills"
# Increase max health + overshield
#	p - Player reference	
func effect(p):
	p.max_health += 20
	p.HUD.health_update(p.max_health,20)
	p.health += 50
	p.HUD.health_update(p.health)
