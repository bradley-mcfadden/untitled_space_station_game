extends Item


# Init
func _init():
	image = texture
	title = "Shells"


# Add durability to play's current gun
#	player - Target of effect
func effect(player:KinematicBody2D):
	var c_gun:Gun 
	for child in player.get_children():
		if child is Gun:
			c_gun = child
	c_gun.current_durability += c_gun.clip_size * 2
	player.HUD._on_update_gun(c_gun)
