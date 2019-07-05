extends Item
#class_name TwoPercent
# Init
func _ready():
	image = texture
	title = "TwoPercent"
# Increment max health and health of Player
#	p - Player reference	
func effect(p):
	p.max_health += 20
	p.HUD.health_update(p.maxHealth,20)
	p.health += 20
	p.HUD.health_update(p.health)