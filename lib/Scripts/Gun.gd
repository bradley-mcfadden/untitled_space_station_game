extends AnimatedSprite
class_name Gun
signal shoot(bullet, direction, origin, speed, damage)
signal weaponSwap(weapon)
signal updateGun(weapon)
var Bullet = load("res://Scenes/Bullet.tscn")
export var rateOfFire:float
export var reloadTime:float
export var clipSize:int
export var pellets:int
export var bulletVelocity:int
export var degreeSpread:int
export var bulletDamage:int
onready var actualBullets
onready var canFire
onready var ReloadTimer
onready var RateOfFireTimer
onready var radianSpread
onready var gunName
onready var rot

# Init
func _ready():
	position.y += 12
	flip_h = true
	craft()
	self.connect("shoot",get_parent().get_parent(), "on_Gun_shoot")
	ReloadTimer = Timer.new()
	centered = true
	ReloadTimer.wait_time = reloadTime * PlayerVariables.reloadMultiplier
	ReloadTimer.one_shot = true
	# on reload 
	ReloadTimer.connect("timeout",self,"on_ReloadTimer_timeout")
	add_child(ReloadTimer)
	RateOfFireTimer = Timer.new()
	RateOfFireTimer.wait_time = rateOfFire * PlayerVariables.fireRateMultiplier
	RateOfFireTimer.one_shot = true
	# on rate of fire refresh 
	RateOfFireTimer.connect("timeout",self,"on_RateOfFireTimer_timeout")
	add_child(RateOfFireTimer)
	actualBullets = int(clipSize*PlayerVariables.clipMultiplier)
	canFire = true
	radianSpread = deg2rad(degreeSpread)
	self.connect("weaponSwap",get_parent().get_node("HUD"),"_on_weaponSwap")
	self.connect("updateGun",get_parent().get_node("HUD"),"_on_updateGun")
	#emit_signal("weaponSwap",self)
	
# Update sprite and handle firing input
#	delta - Time since last frame
func _process(delta):
	if get_parent().health > 0 and !get_parent().onLadder:
		look_at(get_global_mouse_position())
		rot = get_global_mouse_position() - global_position
		adjust_pos() 
		if rot.x > 0:
			flip_v = false
		else:
			flip_v = true
# Placeholder function to be replaced by child classes
func craft():
	pass

# Spawn a bullet
func fire_gun():
	if canFire && rot != null:
		canFire = false
		actualBullets -= 1
		emit_signal("updateGun",self)
		for i in range(pellets):
			var spread = rand_range(-radianSpread/2,radianSpread/2)
			var rot2 = atan2(rot.y, rot.x)
			emit_signal("shoot", Bullet,rot2+spread, self.global_position, bulletVelocity, bulletDamage) 
		if actualBullets == 0:
			ReloadTimer.start()
		else:
			RateOfFireTimer.start()

# Meant to adjust position of gun in character's
# hand when sprite flips.
func adjust_pos():
	pass

# Event handler when reload timer is up	
func on_ReloadTimer_timeout():
	actualBullets = int(clipSize*PlayerVariables.clipMultiplier)
	canFire = true
	emit_signal("updateGun",self)
	
# Event handler for when rate of fire timer is up
func on_RateOfFireTimer_timeout():
	canFire = true