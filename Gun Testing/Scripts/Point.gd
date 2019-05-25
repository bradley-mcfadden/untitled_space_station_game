# Describes a Point on a grid
extends Node

class_name Point

var x:int
var y:int

func _init(x:int,y:int):
	self.x = x
	self.y = y
	
func copy():
	var copy = get_script().new(x,y)
	return copy
	
func equals(p) -> bool:
	if x == p.x and y == p.y:
		return true
	return false