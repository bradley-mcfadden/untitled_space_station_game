extends Sprite
class_name ActiveItem
var title:String
var p:Player
var cooldown:int
var isReady:bool

# Used to initialize variables necessary for script
func init():
	isReady = true	

# Abstract function to be extended
func active_effect():
	pass