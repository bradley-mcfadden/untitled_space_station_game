extends Gun


# Init
func _init():
	title = "Shotgun"


# Init
func _ready():
	position.y += 4
	emit_signal("weapon_swap",self)


# Sets properties of gun
func craft():
	rate_of_fire = 0.5
	reload_time = 3 
	clip_size = 2
	pellets = 5
	degree_spread = 15
	bullet_velocity = 800
	bullet_damage = 50
	current_durability = 20


# Adjust position of gun when Player sprites rotates
func adjust_pos():
	if mouse_vector.x > 0:
		position.x = 12
	else:
		position.x = -6