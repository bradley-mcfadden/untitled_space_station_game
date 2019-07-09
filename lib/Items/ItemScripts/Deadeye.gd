extends Item

# Init
func _init():
	image = texture
	title = "Deadeye"	
	
# Give more damage and accuracy.
#	p - Player to give effect to
func effect(p):
	PlayerVariables.damageMultiplier *= 1.1
	PlayerVariables.accuracyMultiplier *= 0.93


