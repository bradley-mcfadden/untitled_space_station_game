extends Item


# Init 
func _init():
	image = texture
	title = "Marine Helmet"


# Give an overshield effect
#	player - Player target
func effect(player:KinematicBody2D):
	player.health += 50
	player.HUD.health_update(player.health)