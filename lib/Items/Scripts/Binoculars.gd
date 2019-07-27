extends Item


# Init
func _init():
	image = texture
	title = "Binoculars"

	
# Make bullet spread of Player tighter
#	player - Target of effect	
func effect(player:KinematicBody2D):
	PlayerVariables.accuracy_multiplier *= 0.95


