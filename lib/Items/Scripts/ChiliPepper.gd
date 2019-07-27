extends Item


# Init
func _init():
	image = texture
	title = "Chili Pepper"


# Increase player damage
#	player - Player target.
func effect(player:KinematicBody2D):
	PlayerVariables.damage_multiplier *= 1.1