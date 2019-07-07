extends Item

# Init 
func _init():
	image = texture
	title = "Full Metal Jacket"
	
# Effect gives a significant damage increase for a chunk of health.
#	p - Player to apply effect to.
func effect(p):
	p.maxHealth += 50
	p.HUD.health_update(p.health,50)
	PlayerVariables.damageMultiplier *= 1.1

