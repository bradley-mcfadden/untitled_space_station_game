extends Node

class_name Rect
var Point = load("res//Scripts/Point.gd")
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
	
func copy() -> Rect:
	return Rect.new(xsize,ysize,low)
	
func equals(r:Rect) -> bool:
	if low.equals(r.low) and high.equals(r.high):
		return true
	return false
	
func dist_origin() -> float:
	var deltax = low.x+(xsize/2)
	var deltay = low.y+(ysize/2)
	return sqrt((deltax*deltax)+(deltay*deltay))
	
func dist(r:Rect) -> float:
	var deltax = (r.low.x + (r.xsize/2)) - (low.x+(xsize/2))
	var deltay = (r.low.y + (r.ysize/2)) - (low.y+(ysize/2))
	return sqrt((deltax*deltax)+(deltay*deltay))
	
func is_inside(r:Rect) -> bool:
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
	return "Corner: ("+low.x+", "+low.y+") Size: ("+xsize+", "+ysize+")"

func image(tm:TileMap):
	for i in range(low.x+1,high.x):
		for j in range(low.y+1,high.y):
			tm.set_cell(i,j,1)