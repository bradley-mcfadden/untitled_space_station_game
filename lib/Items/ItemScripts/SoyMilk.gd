extends Item

# Init 
func _init():
	image = texture
	title = "Soy Milk"	
	
# Improve the knockback of Player's attacks
#	p - Player to apply effect on.
func effect(p):
	PlayerVariables.knockbackMultiplier *= 1.5


