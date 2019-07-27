extends Item


# Init 
func _init():
	image = texture
	title = "Soy Milk"


# Improve the knockback of Player's attacks
#	player - Player to apply effect on.
func effect(player:KinematicBody2D):
	PlayerVariables.knockback_multiplier *= 1.5


