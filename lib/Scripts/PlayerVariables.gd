extends Node

var damage_multiplier:float = 1
var reload_multiplier:float = 1
var fire_rate_multiplier:float = 1
var clip_size_multiplier:float = 1
var jump_multiplier:float = 1
var accuracy_multiplier:float = 1
var knockback_multiplier:float = 1
var pellet_multiplier:float = 1


# Put all variables back to initial state
func reset():
	damage_multiplier = 1
	reload_multiplier = 1
	fire_rate_multiplier = 1
	clip_size_multiplier = 1
	jump_multiplier = 1
	accuracy_multiplier = 1
	knockback_multiplier = 1
	pellet_multiplier = 1