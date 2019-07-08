extends Item

# Init
func _init():
	image = texture
	title = "Drum Clip"

# Make magazine size of clip bigger and fire rate slower
#	p - Player to apply effect to	
func effect(p):
	PlayerVariables.clipMultiplier *= 2.0
