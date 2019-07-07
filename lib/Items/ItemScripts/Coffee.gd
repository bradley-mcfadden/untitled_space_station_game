extends Item

# Init
func _init():
	image = texture
	title = "Coffee"
	
# Effect
#	p - Player
func effect(p):
	p.movespeed *= 1.25
	p.speedCap *= 1.10