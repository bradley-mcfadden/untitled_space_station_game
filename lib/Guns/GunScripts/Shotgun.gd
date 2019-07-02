extends Gun

# Init
func _ready():
	var GunSpriteFrames = preload("res://Guns/GunSprites/Shotgun.tres")
	position.y += 4
	set_sprite_frames(GunSpriteFrames)
	emit_signal("weaponSwap",self)

# Sets properties of gun
func craft():
	rateOfFire = 0.5
	reloadTime = 3 
	clipSize = 2
	pellets = 8
	degreeSpread = 15
	bulletVelocity = 800
	gunName = "Shotgun"
	bulletDamage = 50
	
# Adjust position of gun when Player sprites rotates
#	rot - Rotation of gun 
func adjust_pos(rot:Vector2):
	#print("in here")
	if rot.x > 0:
		position.x = 12
	else:
		position.x = -6