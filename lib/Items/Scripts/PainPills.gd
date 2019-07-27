extends Item


# Init
func _init():
	image = texture
	title = "Pain Pills"


# Increase max health + overshield
#	player - Player reference	
func effect(player):
	player.max_health += 20
	player.HUD.health_update(player.max_health,20)
	player.health += 50
	player.HUD.health_update(player.health)
