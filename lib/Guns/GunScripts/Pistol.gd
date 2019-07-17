extends Gun

# Init
func _ready():
	var GunSpriteFrames = preload("res://Guns/GunSprites/Pistol.tres")
	position.y+=4
	set_sprite_frames(GunSpriteFrames)
	emit_signal("weaponSwap",self)

# Sets the properties of the pistol
func craft():
	rateOfFire = 1.0/2.0
	reloadTime = 1
	clipSize = 6
	pellets = 1
	degreeSpread = 15
	bulletVelocity = 600
	gunName = "Pistol"
	bulletDamage = 50
	currentDurability = 60
	#var GunSpriteFrames = preload("res://Gun Sprites/GodotGun.tres")
	#set_sprite_frames(GunSpriteFrames)
	
# Adjusts the position of pistol when Player sprite is flipped
func adjust_pos():
	#print("in here")
	if rot.x > 0:
		position.x = 8
	else:
		position.x = -10