extends Item

# Init 
func _init():
	image = texture
	title = "Bottle Of Rage"
	
# Effect gives a significant damage increase for a chunk of health.
# p - Player to apply effect on
func effect(p):
	p.maxHealth -= 50
	p.take_damage(50,Vector2(0,0))
	p.HUD.health_update(0,-50)
	p.HUD.health_update(0,0)
	PlayerVariables.damageMultiplier *= 1.3