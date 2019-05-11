extends Gun

# signal shoot(bul, dir, pos, speed)
func _ready():
	var GunSpriteFrames = preload("res://Gun Sprites/Shotgun.tres")
	set_sprite_frames(GunSpriteFrames)

func craft():
	rateOfFire = 0.5
	reloadTime = 1
	clipSize = 6
	pellets = 1
	degreeSpread = 15
	bulletVelocity = 600
	#var GunSpriteFrames = preload("res://Gun Sprites/GodotGun.tres")
	#set_sprite_frames(GunSpriteFrames)
	
func adjust_pos(rot:Vector2):
	print("in here")
	if rot.x > 0:
		position.x = 12
	else:
		position.x = -6