extends Node
class_name Edge
var a # Rect
var b # Rect

func _init(a1:Rect, b2:Rect): 
	var magA = sqrt((a1.low.x*a1.low.x)+(a1.low.y*a1.low.y))  
	var magB = sqrt((b2.low.x*b2.low.x)+(b2.low.y*b2.low.y))  
	if magB <= magA:
      self.a = b2.copy()
      self.b = a1.copy()
	else:
      self.a = a1.copy()
      self.b = b2.copy()

func copy(): # Returns an edge
	var copy = get_script().new(a,b)
	return copy
	
func equals(e) -> bool:
	if e.a == a && e.b == b:
		return true
	return false

func to_string() -> String:
	return "Edge "+a.to_string() +" "+ b.to_string()

# Sets edges of the tile map to a dark tile which is passable
func image_empty(tm:TileMap):
	if a.low.x - b.low.x < 0:
		for i in range(a.low.x+(a.xsize/2),b.low.x+(b.xsize/2)+1):
			tm.set_cell(i,b.low.y+(b.ysize/2),1)
			tm.set_cell(i,b.low.y+(b.ysize/2)+1,1)
	else:
		for i in range(b.low.x+(b.xsize/2),a.low.x+(a.xsize/2)+1):
			tm.set_cell(i,b.low.y+(b.ysize/2),1)
			tm.set_cell(i,b.low.y+(b.ysize/2)+1,1)
	if a.low.y - b.low.y < 0:
		for i in range(a.low.y+(a.ysize/2),b.low.y+(b.ysize/2)+2):
			tm.set_cell(a.low.x+(a.xsize/2),i,1)
			tm.set_cell(a.low.x+(a.xsize/2)+1,i,1)
	else: 
		for i in range(b.low.y+(b.ysize/2),a.low.y+(a.ysize/2)+2):
			tm.set_cell(a.low.x+(a.xsize/2),i,1)
			tm.set_cell(a.low.x+(a.xsize/2)+1,i,1)

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