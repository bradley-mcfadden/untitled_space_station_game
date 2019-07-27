extends Item


# Init
func _init():
	image = texture
	title = "Dilopia"


# Increase pellet count of player's guns
#	player - Player to apply effect to
func effect(player:KinematicBody2D):
	PlayerVariables.pellet_multiplier *= 1.5


