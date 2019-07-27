extends Item


# Init
func _init():
	image = texture
	title = "Batteries"

	
# What the item does to the player, p
#	player - Target of effect
func effect(player:KinematicBody2D):
	player.speed_cap *= 1.4