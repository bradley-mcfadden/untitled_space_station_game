extends Item


# Init 
func _init():
	image = texture
	title = "Phone Book"


# Give an overshield effect
#	player - Player target
func effect(player:KinematicBody2D):
	player.health += 70
	player.max_health += 20
	player.HUD.health_update(player.health,20)