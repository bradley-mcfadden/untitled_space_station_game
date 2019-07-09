extends Item

# Init
func _init():
	image = texture
	title = "Old Jersey"	

# Make target jump higher
#	p - Target
func effect(p):
	PlayerVariables.jumpMultiplier *= 1.1
