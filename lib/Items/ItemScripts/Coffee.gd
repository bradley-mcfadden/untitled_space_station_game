extends Item

# Init
func _ready():
	image = texture
	title = "Coffee"
# Effect
#	p - Player
func effect(p):
	p.movespeed *= 1.25
	p.speedCap *= 1.10