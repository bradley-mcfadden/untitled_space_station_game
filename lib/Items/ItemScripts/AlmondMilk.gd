extends Item

# Init
func _init():
	image = texture
	title = "Almond Milk"

# Give player an extended DamageTimer and double damage during the timer
#	p - Player to apply effect to
func effect(p):
	p.DamageTimer.wait_time *= 2
	p.veganPower = true
