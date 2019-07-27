extends Item


# Init
func _init():
	image = texture
	title = "Coffee"


# Effect
#	player - Player
func effect(player:KinematicBody2D):
	player.movespeed *= 1.25
	player.speed_cap *= 1.10