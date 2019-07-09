extends Item

# Init
func _init():
	image = texture
	title = "Binoculars"
	
# Make bullet spread of Player tighter
#	p - Target of effect	
func effect(p):
	PlayerVariables.accuracyMultiplier *= 0.95


