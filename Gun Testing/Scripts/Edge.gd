extends Node
class_name Edge
var a:Rect
var b:Rect

# Create a new edge between two rects
#	a1 - First rect
#	a2 - Second rect
func _init(a1:Rect, b2:Rect): 
	var magA = sqrt((a1.low.x*a1.low.x)+(a1.low.y*a1.low.y))  
	var magB = sqrt((b2.low.x*b2.low.x)+(b2.low.y*b2.low.y))  
	if magB <= magA:
      self.a = b2.copy()
      self.b = a1.copy()
	else:
      self.a = a1.copy()
      self.b = b2.copy()

# Returns a copy
#	return - Copy of self
func copy():
	var copy = get_script().new(a,b)
	return copy
	
# Compares two edges
# e - Edge to compare to
# return - Are these edges equal?
func equals(e) -> bool:
	if e.a == a && e.b == b:
		return true
	return false

# Prints the states of the two rects
# return - Description of edge
func to_string() -> String:
	return "Edge "+a.to_string() +" "+ b.to_string()

# Sets interior of the edges of the tile map to a dark tile which is passable
# tm - TileMap to project on
# doorsClosed - Whether or not door closed tiles are created
func image_empty(tm:TileMap,doorsClosed:bool):
	if a.low.x - b.low.x < 0:
		for i in range(a.low.x+(a.xsize/2),b.low.x+(b.xsize/2)+1):
			tm.set_cell(i,b.low.y+(b.ysize/2),2)
			tm.set_cell(i,b.low.y+(b.ysize/2)+1,2)
			if ((i == b.low.x) || (i == a.high.x && b.low.y+b.ysize/2 < a.high.y && b.low.y+b.ysize/2 > a.low.y)):
				if doorsClosed:
					tm.set_cell(i,b.low.y+(b.ysize/2),5)
					tm.set_cell(i,b.low.y+(b.ysize/2)+1,6)
				else:
					tm.set_cell(i,b.low.y+(b.ysize/2),10)
					tm.set_cell(i,b.low.y+(b.ysize/2)+1,10)
	else:
		for i in range(b.low.x+(b.xsize/2),a.low.x+(a.xsize/2)+1):
			tm.set_cell(i,b.low.y+(b.ysize/2),2)
			tm.set_cell(i,b.low.y+(b.ysize/2)+1,2)
			if (i == b.high.x || (i == a.low.x && b.low.y+b.ysize/2 < a.high.y && b.low.y+b.ysize/2 > a.low.y)):
				if doorsClosed:
					tm.set_cell(i,b.low.y+(b.ysize/2),5)
					tm.set_cell(i,b.low.y+(b.ysize/2)+1,6)
				else:
					tm.set_cell(i,b.low.y+(b.ysize/2),10)
					tm.set_cell(i,b.low.y+(b.ysize/2)+1,10)
	if a.low.y - b.low.y < 0:
		for i in range(a.low.y+(a.ysize/2),b.low.y+(b.ysize/2)+2):
			tm.set_cell(a.low.x+(a.xsize/2),i,2)
			tm.set_cell(a.low.x+(a.xsize/2)+1,i,2)
			if (i == a.high.y || (i == b.low.y && a.low.x + a.xsize/2 < b.high.x && a.low.x + a.xsize/2 > b.low.x)):
				if doorsClosed:
					tm.set_cell(a.low.x+(a.xsize/2),i,7)
					tm.set_cell(a.low.x+(a.xsize/2)+1,i,8)
				else:
					tm.set_cell(a.low.x+(a.xsize/2),i,9)
					tm.set_cell(a.low.x+(a.xsize/2)+1,i,9)
	else: 
		for i in range(b.low.y+(b.ysize/2),a.low.y+(a.ysize/2)+2):
			tm.set_cell(a.low.x+(a.xsize/2),i,2)
			tm.set_cell(a.low.x+(a.xsize/2)+1,i,2)
			if (i == a.low.y || (i == b.high.y && a.low.x + a.xsize/2 < b.high.x && a.low.x + a.xsize/2 > b.low.x)):
				if doorsClosed:
					tm.set_cell(a.low.x+(a.xsize/2),i,7)
					tm.set_cell(a.low.x+(a.xsize/2)+1,i,8)
				else:
					tm.set_cell(a.low.x+(a.xsize/2),i,9)
					tm.set_cell(a.low.x+(a.xsize/2)+1,i,9)

# Draws the walls of the edges to an impassable tile
# tm - TileMap to project on
func image_walls(tm:TileMap):
	if a.low.x - b.low.x < 0:
		for i in range(a.low.x+(a.xsize/2)-1,b.low.x+(b.xsize/2)+2):
			tm.set_cell(i,b.low.y+(b.ysize/2)+2,0)
			tm.set_cell(i,b.low.y+(b.ysize/2)-1,0)
	else:
		for i in range(b.low.x+(b.xsize/2)-1,a.low.x+(a.xsize/2)+2):
			tm.set_cell(i,b.low.y+(b.ysize/2)+2,0)
			tm.set_cell(i,b.low.y+(b.ysize/2)-1,0)
	if a.low.y - b.low.y < 0:
		for i in range(a.low.y+(a.ysize/2)-1,b.low.y+(b.ysize/2)+3):
			tm.set_cell(a.low.x+(a.xsize/2)-1,i,0)
			tm.set_cell(a.low.x+(a.xsize/2)+2,i,0)
	else: 
		for i in range(b.low.y+(b.ysize/2)-1,a.low.y+(a.ysize/2)+3):
			tm.set_cell(a.low.x+(a.xsize/2)-1,i,0)
			tm.set_cell(a.low.x+(a.xsize/2)+2,i,0)

# Checks a and b fields to determine whether edge contains r
#	r - Rect to search for
#	return _ Was the rect found?
func contains(r:Rect)->bool:
	if r == null:
		return false
	if r.equals(a) || r.equals(b):
		return true
	return false