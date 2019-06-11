extends Node

class_name Rect
var low:Point
var high:Point
var xsize:int
var ysize:int
var overlap = false
var prefab:int
var border 
var type = 1
# var room = load("res://Scenes/Room1.tscn")

# Create a new Rect
#	xsize - Width of the rect
#	ysize - Height of the rect
#	low - Top left corner of the rect
func _init(xsize,ysize,low,hasBorder=false):
	self.low = low.copy()
	self.xsize = xsize
	self.ysize = ysize
	high = Point.new(low.x+xsize,low.y+ysize)
	border = hasBorder
	
# Returns a copy of this Rect
#	return - Copy of self
func copy():
	var copy = get_script().new(xsize,ysize,low)
	return copy
	
# Checks to see if two rects are the same
#	return - Are these the same?
func equals(r) -> bool:
	if low.equals(r.low) and high.equals(r.high):
		return true
	return false
	
# Returns distance from center to the origin
#	return - Distance to the origin
func dist_origin() -> float:
	var deltax = low.x+(xsize/2)
	var deltay = low.y+(ysize/2)
	return sqrt((deltax*deltax)+(deltay*deltay))
	
# Returns distance between the midpoinbts of two rects
#	r - Rect to measure against
#	return - Distance between two rects
func dist(r) -> float:
	var deltax = (r.low.x + (r.xsize/2)) - (low.x+(xsize/2))
	var deltay = (r.low.y + (r.ysize/2)) - (low.y+(ysize/2))
	return sqrt((deltax*deltax)+(deltay*deltay))
	
# Check if another rect is inside this
#	r - Rect to compare against
#	return - Whether or not the rects overlap
func is_inside(r) -> bool:
	if !border:
	    if ( 
        !(!(low.x >= r.low.x && high.y <= r.high.y && low.x <= r.high.x && low.y >= r.high.y) 
        && !(low.x >= r.low.x && high.y <= r.high.y && high.x <= r.high.x && low.y >= r.low.y)
        && !(low.x >= r.low.x && low.y >= r.low.y && low.x <= r.high.x && low.y <= r.high.y)
        && !(high.y <= r.high.y && high.y >= r.low.y && high.x <= r.high.x && high.x >= r.low.x)
        && !(low.y <= r.low.y && high.y >= r.low.y && low.x >= r.low.x && low.x <= r.high.x))
        ):
    		return true;
	high.x += 2
	high.y += 2
	r.high.x += 2
	r.high.y += 2
	if ( 
    !(!(low.x >= r.low.x && high.y <= r.high.y && low.x <= r.high.x && low.y >= r.high.y) 
    && !(low.x >= r.low.x && high.y <= r.high.y && high.x <= r.high.x && low.y >= r.low.y)
    && !(low.x >= r.low.x && low.y >= r.low.y && low.x <= r.high.x && low.y <= r.high.y)
    && !(high.y <= r.high.y && high.y >= r.low.y && high.x <= r.high.x && high.x >= r.low.x)
    && !(low.y <= r.low.y && high.y >= r.low.y && low.x >= r.low.x && low.x <= r.high.x))
    ):
		high.x -= 2
		high.y -= 2
		r.high.x -= 2
		r.high.y -= 2
		return true
	high.x -= 2
	high.y -= 2
	r.high.x -= 2
	r.high.y -= 2
	return false

# Return the state of the room
#	return - State of the room
func to_string() -> String:
	return "Corner: ("+str(low.x)+", "+str(low.y)+") Size: ("+str(xsize)+", "+str(ysize)+")"

# DEPRECATED
# Draw the walls and interior of the room
#	tm - TileMap to project on, min of two defined tiles
func image(tm:TileMap):
	for i in range(low.x,high.x+1):
		for j in range(low.y,high.y+1):
			if i > low.x and i < high.x and j > low.y and j < high.y:
				tm.set_cell(i,j,1)
			else:
				tm.set_cell(i,j,0)

# Draw the walls of the tilemap without the interior
#	tm - TileMap to project on, needs at least two tiles
func image_ext(tm:TileMap):
	for i in range(low.x,high.x+1):
		for j in range(low.y,high.y+1):
			if i > low.x and i < high.x and j > low.y and j < high.y:
				pass
			else:
				tm.set_cell(i,j,0)

# Draw the room on the tilemap without the walls			
func image_int(tm:TileMap):
	for i in range(low.x,high.x+1):
		for j in range(low.y,high.y+1):
			if i > low.x and i < high.x and j > low.y and j < high.y:
				tm.set_cell(i,j,1)
				
# Determines whether or not position vector given is inside bounds of rect
#	position - Target to check
#	return - Was the target found?
func is_target_inside(position:Vector2)->bool:
	if position.x >= low.x && position.x <= high.x && position.y >= low.y && position.y <= high.y:
		return true
	return false