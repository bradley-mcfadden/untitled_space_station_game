extends Gun

# Init
func _ready():
	var GunSpriteFrames = preload("res://GunSprites/SMG.tres")
	set_sprite_frames(GunSpriteFrames)
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
	bulletDamage = 50
	#var GunSpriteFrames = preload("res://Gun Sprites/GodotGun.tres")
	#set_sprite_frames(GunSpriteFrames)
	
# Handles adjusting position of Gun when rotated
func adjust_pos(rot:Vector2):
	#print("in here")
	if rot.x > 0:
		position.x = 15
	else:
		position.x = -3