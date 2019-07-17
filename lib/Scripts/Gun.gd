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
#onready var maxDurability:int
onready var currentDurability:int 
onready var actualBullets
onready var canFire
onready var ReloadTimer:Timer
onready var RateOfFireTimer:Timer
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
	actualBullets = 0
	canFire = false
	on_ReloadTimer_timeout()
	radianSpread = deg2rad(degreeSpread)
	self.connect("weaponSwap",get_parent().get_node("HUD"),"_on_weapon_swap")
	self.connect("updateGun",get_parent().get_node("HUD"),"_on_update_gun")
	# emit_signal("weaponSwap",self)
	
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
		for i in range(int(pellets*PlayerVariables.pelletMultiplier)):
			var spread = rand_range(-radianSpread/2,radianSpread/2)*PlayerVariables.accuracyMultiplier
			var rot2 = atan2(rot.y, rot.x)
			emit_signal("shoot", Bullet,rot2+spread, self.global_position, bulletVelocity, bulletDamage) 
		if actualBullets <= 0:
			if currentDurability > 0:
				ReloadTimer.start()
			else:
				canFire = false
				if get_parent().gunInventory.guns.size() > 1:
					get_parent().gunInventory.remove_current()
					get_parent().currentGun = get_parent().gunInventory.get_current()
					queue_free()
		else:
			RateOfFireTimer.start()
	elif !canFire && currentDurability > 0 && ReloadTimer.paused == false && actualBullets == 0:
		ReloadTimer.start()

# Meant to adjust position of gun in character's
# hand when sprite flips.
func adjust_pos():
	pass

# Event handler when reload timer is up	
func on_ReloadTimer_timeout():
	var potentialClip = int(clipSize*PlayerVariables.clipMultiplier)
	actualBullets = potentialClip if currentDurability >= potentialClip else currentDurability
	currentDurability -= actualBullets
	canFire = true
	emit_signal("updateGun",self)
	
# Event handler for when rate of fire timer is up
func on_RateOfFireTimer_timeout():
	canFire = true