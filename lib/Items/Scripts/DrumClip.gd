extends Item


# Init
func _init():
	image = texture
	title = "Drum Clip"


# Make magazine size of clip bigger and fire rate slower
#	player - Player to apply effect to	
func effect(player:KinematicBody2D):
	PlayerVariables.clip_size_multiplier *= 2.0
