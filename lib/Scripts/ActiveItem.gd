extends Sprite
class_name ActiveItem


var title:String
var player:KinematicBody2D
var cooldown:int
var is_ready:bool


# Used to initialize variables necessary for script
func init():
	player = get_parent()
	is_ready = true	


# Abstract function to be extended
func active_effect():
	pass