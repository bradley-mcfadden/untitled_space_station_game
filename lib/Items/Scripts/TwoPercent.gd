extends Item


# Init
func _init():
	image = texture
	title = "Two Percent"


# Increment max health and health of Player
#	player - Player reference	
func effect(player:KinematicBody2D):
	player.max_health += 20
	player.hud.health_update(player.max_health, 20)
	player.health += 20
	player.hud.health_update(player.health)