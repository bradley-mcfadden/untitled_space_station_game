extends Item


# Init
func _init():
	image = texture
	title = "Elixir of Life"


# Increase max health and restore life to full
#	player - Player reference	
func effect(player:KinematicBody2D):
	player.max_health += 40
	player.HUD.health_update(player.max_health, 20)
	player.health = player.max_health
	player.HUD.health_update(player.health)
