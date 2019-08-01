extends Item


# Init
func _init():
	image = texture
	title = "Cookies"	


# Health 30% of player health
#	player - Player to heal
func effect(player:KinematicBody2D):
	player.health += int(player.health * 0.15)
	if player.health > player.max_health:
		player.health = player.max_health
	player.hud.health_update(player.health, 0)

