extends Item

# Init 
func _ready():
	image = texture
	title = "Bottle Of Rage"
	
# Effect gives a significant damage increase for a chunk of health.
func effect(p):
	p.max_health -= 50
	p.take_damage(50,Vector2(0,0))
	p.HUD.health_update(0,-50)
	p.HUD.health_update(0,0)
	PlayerVariables.damageMultiplier *= 1.3