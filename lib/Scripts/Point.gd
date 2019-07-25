# Describes a Point on a grid
extends Object

class_name Point

var x:int
var y:int

# Create a point
#	x - X value of point
#	y - Y value of point
func _init(x:int,y:int):
	self.x = x
	self.y = y
	
# Copy method
#	return - Copy of self
func copy():
	var copy = get_script().new(x,y)
	return copy
	
# Test for equality
#	return - Is this equal to other point?
func equals(p) -> bool:
	if x == p.x and y == p.y:
		return true
	return false