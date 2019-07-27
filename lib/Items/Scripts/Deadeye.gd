extends Item


# Init
func _init():
	image = texture
	title = "Deadeye"	


# Give more damage and accuracy.
#	player - Player to give effect to
func effect(player:KinematicBody2D):
	PlayerVariables.damage_multiplier *= 1.1
	PlayerVariables.accuracy_multiplier *= 0.93


