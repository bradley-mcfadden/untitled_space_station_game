extends Item

# Init
func _init():
	image = texture
	title = "Chili Pepper"

# Increase player damage
#	p - Player target.
func effect(p):
	PlayerVariables.damageMultiplier *= 1.1