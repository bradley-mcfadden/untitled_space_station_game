extends Item

# Init
func _ready():
	image = texture
	title = "Batteries"
	
# What the item does to the player, p
#	p - Target of effect
func effect(p):
	p.speedCap *= 1.4