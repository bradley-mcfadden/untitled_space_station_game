extends Item

# Init
func _init():
	image = texture
	title = "Dilopia"

# Increase pellet count of player's guns
#	p - Player to apply effect to
func effect(p):
	PlayerVariables.pelletMultiplier *= 1.5


