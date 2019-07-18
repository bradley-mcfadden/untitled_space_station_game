extends Gun

# Init
func _init():
	title = "Shotgun"

# Init
func _ready():
	position.y += 4
	emit_signal("weaponSwap",self)

# Sets properties of gun
func craft():
	rateOfFire = 0.5
	reloadTime = 3 
	clipSize = 2
	pellets = 5
	degreeSpread = 15
	bulletVelocity = 800
	gunName = "Shotgun"
	bulletDamage = 50
	currentDurability = 20
	
# Adjust position of gun when Player sprites rotates
#	rot - Rotation of gun 
func adjust_pos():
	#print("in here")
	if rot.x > 0:
		position.x = 12
	else:
		position.x = -6