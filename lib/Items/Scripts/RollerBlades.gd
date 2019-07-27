extends Item


# Init 
func _init():
	image = texture
	title = "Roller Blades"


# Effect
#	player - Player
func effect(player:KinematicBody2D):
	player.movespeed *= 1.55
	player.speed_cap *= 1.10