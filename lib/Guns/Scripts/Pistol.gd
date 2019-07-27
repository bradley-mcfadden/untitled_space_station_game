extends Gun


# Init 
func _init():
	title = "Pistol"


# Init
func _ready():
	position.y += 4
	emit_signal("weapon_changed", self)


# Sets the properties of the pistol
func craft():
	rate_of_fire = 1.0 / 2.0
	reload_time = 1
	clip_size = 6
	pellets = 1
	degree_spread = 15
	bullet_velocity = 600
	bullet_damage = 50
	current_durability = 60


# Adjusts the position of pistol when Player sprite is flipped
func adjust_pos():
	if mouse_vector.x > 0:
		position.x = 8
	else:
		position.x = -10