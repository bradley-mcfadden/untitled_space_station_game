extends Item


# Init 
func _init():
	image = texture
	title = "Full Metal Jacket"


# Effect gives a significant damage increase for a chunk of health.
#	player - Player to apply effect to.
func effect(player:KinematicBody2D):
	player.max_health += 50
	player.HUD.health_update(player.health, 50)
	PlayerVariables.damage_multiplier *= 1.1

