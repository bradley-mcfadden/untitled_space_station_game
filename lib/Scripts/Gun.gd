extends Sprite
class_name Gun


signal bullet_fired(bullet, direction, origin, speed, damage)
signal weapon_changed(weapon)
signal ammo_changed(weapon)
const BULLET = preload("res://Scenes/Bullet.tscn")
var title:String
export var rate_of_fire:float
export var reload_time:float
export var clip_size:int
export var pellets:int
export var bullet_velocity:int
export var degree_spread:int
export var bullet_damage:int
onready var current_durability:int 
onready var actual_bullets:int
onready var can_fire:bool
onready var reload_timer:Timer
onready var rate_of_fire_timer:Timer
onready var radian_spread:float
onready var mouse_vector:Vector2

# Init
func _ready():
	position.y += 12
	flip_h = true
	craft()
	self.connect("bullet_fired", get_parent().get_parent(), "on_Gun_shoot")
	reload_timer = Timer.new()
	centered = true
	reload_timer.wait_time = reload_time * PlayerVariables.reload_multiplier
	reload_timer.one_shot = true
	# on reload 
	reload_timer.connect("timeout", self, "on_ReloadTimer_timeout")
	add_child(reload_timer)
	rate_of_fire_timer = Timer.new()
	rate_of_fire_timer.wait_time = rate_of_fire * PlayerVariables.fire_rate_multiplier
	rate_of_fire_timer.one_shot = true
	# on rate of fire refresh 
	rate_of_fire_timer.connect("timeout", self, "on_RateOfFireTimer_timeout")
	add_child(rate_of_fire_timer)
	actual_bullets = 0
	can_fire = false
	on_ReloadTimer_timeout()
	radian_spread = deg2rad(degree_spread)
	self.connect("weapon_changed", get_parent().get_node("HUD"), "_on_weapon_swap")
	self.connect("ammo_changed", get_parent().get_node("HUD"), "_on_update_gun")


# Update sprite and handle firing input
#	delta - Time since last frame
func _process(delta:float):
	if get_parent().health > 0 && !get_parent().is_on_ladder:
		look_at(get_global_mouse_position())
		mouse_vector = get_global_mouse_position() - global_position
		adjust_pos() 
		if mouse_vector.x > 0:
			flip_v = false
		else:
			flip_v = true


# Placeholder function to be replaced by child classes
func craft():
	pass


# Spawn a BULLET
func fire_gun():
	if can_fire && mouse_vector != null:
		can_fire = false
		actual_bullets -= 1
		emit_signal("ammo_changed", self)
		for i in range(int(pellets * PlayerVariables.pellet_multiplier)):
			var spread:float = rand_range(-radian_spread / 2, radian_spread / 2) * PlayerVariables.accuracy_multiplier
			var rot2:float = atan2(mouse_vector.y, mouse_vector.x)
			emit_signal("bullet_fired", BULLET, rot2 + spread, self.global_position, bullet_velocity, bullet_damage) 
		if actual_bullets <= 0:
			if current_durability > 0:
				reload_timer.start()
			else:
				if get_parent().gun_inventory.guns.size() > 1:
					get_parent().gun_inventory.remove_current()
					get_parent().equipped_gun = get_parent().gun_inventory.get_current()
					queue_free()
		else:
			rate_of_fire_timer.start()
	elif !can_fire && current_durability > 0 && reload_timer.paused == true && actual_bullets == 0:
		reload_timer.start()


# Meant to adjust position of gun in character's
# hand when sprite flips.
func adjust_pos():
	pass


# Event handler when reload timer is up	
func on_ReloadTimer_timeout():
	var potential_clip:int = int(clip_size * PlayerVariables.clip_size_multiplier)
	actual_bullets = potential_clip if current_durability >= potential_clip else current_durability
	current_durability -= actual_bullets
	can_fire = true
	emit_signal("ammo_changed", self)


# Event handler for when rate of fire timer is up
func on_RateOfFireTimer_timeout():
	can_fire = true