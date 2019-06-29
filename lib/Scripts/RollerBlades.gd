extends Item

# Init 
func _ready():
	image = texture
	title = "Roller Blades"
	
# Effect
#	p - Player
func effect(p):
	p.movespeed *= 1.55
	p.speedCap *= 1.10