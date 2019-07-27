extends Item


# Init 
func _init():
	image = texture
	title = "Bottle Of Rage"


# Effect gives a significant damage increase for a chunk of health.
# player - Player to apply effect on
func effect(player:KinematicBody2D):
	player.max_health -= 50
	player.take_damage(50, Vector2(0, 0))
	player.HUD.health_update(0, -50)
	player.HUD.health_update(0, 0)
	PlayerVariables.damage_multiplier *= 1.3