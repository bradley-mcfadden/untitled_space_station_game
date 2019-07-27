extends Item


# Init
func _init():
	image = texture
	title = "Old Jersey"	


# Make target jump higher
#	player - Target
func effect(player:KinematicBody2D):
	PlayerVariables.jump_multiplier *= 1.1
