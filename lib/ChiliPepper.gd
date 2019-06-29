extends Item

# Init
func _ready():
	image = texture
	title = "Chili Pepper"

# Increase player damage
#	p - Player target.
func effect(p):
	p.damageMultiplier *= 1.1