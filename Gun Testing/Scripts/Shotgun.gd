extends Gun
# signal shoot(bul, dir, pos, speed)
func _ready():
	var GunSpriteFrames = preload("res://Gun Sprites/Shotgun.tres")
	position.y += 4
	set_sprite_frames(GunSpriteFrames)
	emit_signal("weaponSwap",self)

func craft():
	rateOfFire = 0.5
	reloadTime = 3 
	clipSize = 2
	pellets = 8
	degreeSpread = 15
	bulletVelocity = 800
	gunName = "Shotgun"
	#var GunSpriteFrames = preload("res://Gun Sprites/GodotGun.tres")
	#set_sprite_frames(GunSpriteFrames)
	
func adjust_pos(rot:Vector2):
	#print("in here")
	if rot.x > 0:
		position.x = 12
	else:
		position.x = -6