extends Item


# Init 
func _init():
	image = texture
	title = "Tower Shield"


# Give an overshield effect
#	player - Player target
func effect(player:KinematicBody2D):
	player.health += 70
	player.hud.health_update(player.health)