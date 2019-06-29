extends Item

# Init 
func _ready():
	image = texture
	title = "Full Metal Jacket"
	
# Effect gives a significant damage increase for a chunk of health.
func effect(p):
	p.max_health += 50
	p.HUD.health_update(p.health,50)
	p.damageMultiplier *= 1.1

