extends Node
var Rect = load("res://Scripts/Rect.gd")
class_name Edge
var a # Rect
var b # Rect

func _init(a, b):
	var magA = sqrt((a.low.x*a.low.x)+(a.low.y*a.low.y))  
	var magB = sqrt((b.low.x*b.low.x)+(b.low.y*b.low.y))  
	if magB <= magA:
      self.a = b.copy()
      self.b = a.copy()
	else:
    	self.a = a.copy()
    	self.b = b.copy()

func copy() -> Edge:
	return Edge.new(self.a, self.b)
	
func equals(e:Edge) -> bool:
	if e.a == a && e.b == b:
		return true
	return false

func to_string() -> String:
	return "Edge "+a.to_string() +" "+ b.toString()

func image(tm:TileMap):
	if a.low.x - b.low.x < 0:
		for i in range(a.low.x+(a.xsize/2),b.low.x+(b.xsize/2)+1):
			tm.set_cell(i,b.low.y+(b.ysize/2),1)
	else:
		for i in range(b.low.x+(b.xsize/2),a.low.x+(a.xsize/2)+1):
			tm.set_cell(i,b.low.y+(b.ysize/2),1)
	if a.low.y - b.low.y < 0:
		for i in range(a.low.y+(a.ysize/2),b.low.y+(b.ysize/2)+1):
			tm.set_cell(a.low.x+(a.xsize/2),i,1)
	else: 
		for i in range(b.low.y+(b.ysize/2),a.low.y+(a.ysize/2)+1):
			tm.set_cell(a.low.x+(a.xsize/2),i,1)
			