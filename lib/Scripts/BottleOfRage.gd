extends Item

# Init 
func _ready():
	image = texture
	title = "Bottle Of Rage"
	
# Effect gives a significant damage increase for a chunk of health.
func effect(p):
	p.max_health -= 50
	p.take_damage(50)
	p.damageMultiplier *= 1.3