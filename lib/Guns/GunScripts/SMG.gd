extends Gun

# Init 
func _init():
	title = "SMG"
# Init
func _ready():
	position.y += 3
	position.x += 2
	emit_signal("weaponSwap",self)

# Sets properties of Gun on creation
func craft():
	rateOfFire = 0.1
	reloadTime = 3 
	clipSize = 60
	pellets = 1
	degreeSpread = 25
	bulletVelocity = 700
	gunName = "SMG"
	bulletDamage = 30
	currentDurability = 120
	#var GunSpriteFrames = preload("res://Gun Sprites/GodotGun.tres")
	#set_sprite_frames(GunSpriteFrames)
	
# Handles adjusting position of Gun when rotated
func adjust_pos():
	#print("in here")
	if rot.x > 0:
		position.x = 15
	else:
		position.x = -3