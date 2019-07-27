extends Gun


# Init 
func _init():
	title = "SMG"


# Init
func _ready():
	position.y += 3
	position.x += 2
	emit_signal("weapon_swap",self)


# Sets properties of Gun on creation
func craft():
	rate_of_fire = 0.1
	reload_time = 3 
	clip_size = 60
	pellets = 1
	degree_spread = 25
	bullet_velocity = 700
	bullet_damage = 30
	current_durability = 120


# Handles adjusting position of Gun when rotated
func adjust_pos():
	if mouse_vector.x > 0:
		position.x = 15
	else:
		position.x = -3