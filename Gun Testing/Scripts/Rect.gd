extends Node

class_name Rect
#var Point = load("res//Scripts/Point.gd")
var low
var high
var xsize
var ysize
var overlap = false

func _init(xsize,ysize,low):
	self.low = low.copy()
	self.xsize = xsize
	self.ysize = ysize
	high = Point.new(low.x+xsize,low.y+ysize)
	
func copy():
	var copy = get_script().new(xsize,ysize,low)
	return copy
	
func equals(r) -> bool:
	if low.equals(r.low) and high.equals(r.high):
		return true
	return false
	
func dist_origin() -> float:
	var deltax = low.x+(xsize/2)
	var deltay = low.y+(ysize/2)
	return sqrt((deltax*deltax)+(deltay*deltay))
	
func dist(r) -> float:
	var deltax = (r.low.x + (r.xsize/2)) - (low.x+(xsize/2))
	var deltay = (r.low.y + (r.ysize/2)) - (low.y+(ysize/2))
	return sqrt((deltax*deltax)+(deltay*deltay))
	
func is_inside(r) -> bool:
	if ( 
    !(!(low.x >= r.low.x && high.y <= r.high.y && low.x <= r.high.x && low.y >= r.high.y) 
    && !(low.x >= r.low.x && high.y <= r.high.y && high.x <= r.high.x && low.y >= r.low.y)
    && !(low.x >= r.low.x && low.y >= r.low.y && low.x <= r.high.x && low.y <= r.high.y)
    && !(high.y <= r.high.y && high.y >= r.low.y && high.x <= r.high.x && high.x >= r.low.x)
    && !(low.y <= r.low.y && high.y >= r.low.y && low.x >= r.low.x && low.x <= r.high.x))
    ):
    	return true;
	return false

func to_string() -> String:
	return "Corner: ("+str(low.x)+", "+str(low.y)+") Size: ("+str(xsize)+", "+str(ysize)+")"

func image(tm:TileMap):
	for i in range(low.x,high.x+1):
		for j in range(low.y,high.y+1):
			if i > low.x and i < high.x and j > low.y and j < high.y:
				tm.set_cell(i,j,1)
			else:
				tm.set_cell(i,j,0)