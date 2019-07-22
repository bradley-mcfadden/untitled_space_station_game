extends Sprite
class_name ActiveItem
var title:String
var p
var cooldown:int
var isReady:bool

# Used to initialize variables necessary for script
func init():
	p = get_parent()
	isReady = true	

# Abstract function to be extended
func active_effect():
	pass