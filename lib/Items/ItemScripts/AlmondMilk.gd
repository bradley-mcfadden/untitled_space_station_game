extends Item


# Init
func _init():
	image = texture
	title = "Almond Milk"


# Give player an extended DamageTimer and double damage during the timer
#	player - Player to apply effect to
func effect(player):
	player.damage_timer.wait_time *= 2
	player.vegan_power = true
