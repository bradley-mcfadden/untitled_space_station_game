extends Item

# Init
func _ready():
	image = texture
	title = "Elixir of Life"
# Increase max health and restore life to full
#	p - Player reference	
func effect(p):
	p.max_health += 40
	p.HUD.health_update(p.max_health,20)
	p.health = p.max_health
	p.HUD.health_update(p.health)
