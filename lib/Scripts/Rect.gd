extends Object
class_name Rect


var low:Point
var high:Point
var xsize:int
var ysize:int
var overlap = false
var prefab:int
var border:int 
var type:int
var visited:bool = true
var cleared:bool


# Create a new Rect
#	xsize - Width of the rect
#	ysize - Height of the rect
#	low - Top left corner of the rect
func _init(xsize:int, ysize:int, low:Point, has_border=false):
	self.low = low.copy()
	self.xsize = xsize
	self.ysize = ysize
	high = Point.new(low.x + xsize,low.y + ysize)
	border = has_border
	cleared = false


# Returns a copy of this Rect
#	return - Copy of self
func copy():
	var copy = get_script().new(xsize, ysize, low)
	return copy


# Checks to see if two rects are the same
#	return - Are these the same?
func equals(r) -> bool:
	if low.equals(r.low) && high.equals(r.high):
		return true
	return false


# Returns distance from center to the origin
#	return - Distance to the origin
func dist_origin() -> float:
	var deltax:float = low.x + (xsize / 2)
	var deltay:float = low.y + (ysize / 2)
	return sqrt((deltax * deltax) + (deltay * deltay))


# Returns distance between the midpoinbts of two rects
#	r - Rect to measure against
#	return - Distance between two rects
func dist(r) -> float:
	var deltax:float = (r.low.x + (r.xsize / 2)) - (low.x + (xsize / 2))
	var deltay:float = (r.low.y + (r.ysize / 2)) - (low.y + (ysize / 2))
	return sqrt((deltax * deltax) + (deltay * deltay))


# Used for finding adjacent rooms on a grid like map.
# Rooms adjacent to one another will have a distance of border.
#	r - Room to check this against.
#	return - GlobalVariables.BORDER if adjacent; else dist(r) 
func dist_adjacency(r) -> float:
	if equals(r):
		return 100000.0
	if low.x == r.low.x:
		if low.y < r.low.y:
			return r.low.y - high.y  
		elif low.y > r.low.y:
			return low.y - r.high.y
	elif low.y == r.low.y:
		if low.x < r.low.x:
			return r.low.x - high.x
		elif low.x > r.low.x:
			return low.x - r.high.x
	var deltax = low.x + (xsize / 2) - r.low.x + (r.xsize / 2)
	var deltay = low.y + (ysize / 2) - r.low.y + (r.ysize / 2)
	return float(sqrt((deltax * deltax) + (deltay * deltay)))


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
	high.x  += GlobalVariables.BORDER
	high.y += GlobalVariables.BORDER
	r.high.x += GlobalVariables.BORDER
	r.high.y += GlobalVariables.BORDER
	if ( 
	!(!(low.x >= r.low.x && high.y <= r.high.y && low.x <= r.high.x && low.y >= r.high.y) 
	&& !(low.x >= r.low.x && high.y <= r.high.y && high.x <= r.high.x && low.y >= r.low.y)
	&& !(low.x >= r.low.x && low.y >= r.low.y && low.x <= r.high.x && low.y <= r.high.y)
	&& !(high.y <= r.high.y && high.y >= r.low.y && high.x <= r.high.x && high.x >= r.low.x)
	&& !(low.y <= r.low.y && high.y >= r.low.y && low.x >= r.low.x && low.x <= r.high.x))
	):
		high.x -= GlobalVariables.BORDER
		high.y -= GlobalVariables.BORDER
		r.high.x -= GlobalVariables.BORDER
		r.high.y -= GlobalVariables.BORDER
		return true
	high.x -= GlobalVariables.BORDER
	high.y -= GlobalVariables.BORDER
	r.high.x -= GlobalVariables.BORDER
	r.high.y -= GlobalVariables.BORDER
	return false


# Return the state of the room
#	return - State of the room
func to_string() -> String:
	return "Corner: (" + str(low.x) + ", " + str(low.y) + ") Size: (" + str(xsize) + ", " + str(ysize) + ")"


# DEPRECATED
# Draw the walls and interior of the room
#	tm - TileMap to project on, min of two defined tiles
func image(tm:TileMap):
	for i in range(low.x, high.x + 1):
		for j in range(low.y, high.y + 1):
			if i > low.x && i < high.x && j > low.y && j < high.y:
				tm.set_cell(i, j, 1)
			else:
				tm.set_cell(i, j, 0)


# Draw the walls of the tilemap without the interior
#	tm - TileMap to project on, needs at least two tiles
func image_ext(tm:TileMap):
	for i in range(low.x, high.x + 1):
		for j in range(low.y, high.y + 1):
			if i > low.x && i < high.x && j > low.y && j < high.y:
				pass
			else:
				tm.set_cell(i, j, 0)


# Draw the room on the tilemap without the walls			
func image_int(tm:TileMap):
	for i in range(low.x, high.x + 1):
		for j in range(low.y, high.y + 1):
			if i > low.x && i < high.x && j > low.y && j < high.y:
				tm.set_cell(i, j, 1)


# Determines whether or not position vector given is inside bounds of rect
#	position - Target to check
#	return - Was the target found?
func is_target_inside(position:Vector2)->bool:
	if position.x >= low.x && position.x <= high.x && position.y >= low.y && position.y <= high.y:
		return true
	return false
