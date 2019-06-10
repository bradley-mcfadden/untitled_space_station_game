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

# Returns a door normal of the room that contains this edge
#	r - Room to check
#	return - Normal of doorway
func get_door_normals(r:Rect) -> Vector2:
	if a.low.x < b.low.x:
		# Case 1
		if a.low.y == b.low.y  && a.equals(r):
			return Vector2(1,0)
		# Case 2
		elif a.low.y - b.low.y < 0 && a.equals(r):
			return Vector2(0,1)
		# Case 3
		elif a.equals(r):
			return Vector2(0,-1)
		else:
			return Vector2(-1,0)
	elif a.low.x > b.low.x:
		if a.equals(r):
			# Case 4 - DOUBT
			if b.low.y == a.low.y:
				return Vector2(-1,0)
			# Case 5
			elif a.low.y < b.low.y:
				return Vector2(-1,0)
			# Case 6 - DOUBT
			else:
				return Vector2(0,-1)
		else:
			if a.low.y < b.low.y:
				return Vector2(0,-1)
			return Vector2(1,0)
	else:
		# Case 7
		if a.equals(r):
			return Vector2(0,1)
		# Case 7
		else:
			return Vector2(0,-1)
	
# If this edge contains the r, return the door inside r
#	r - Which room's door?
#	return - Map vector location of door
func get_doors(r:Rect) -> Vector2:
	if a.low.x < b.low.x:
		# Case 1
		if a.low.y == b.low.y  && a.equals(r):
			return Vector2(a.high.x,b.low.y+(b.ysize/2))
		# Case 2
		elif a.low.y < b.low.y && a.equals(r):
			return Vector2(a.low.x+(a.xsize/2),a.high.y)
		# Case 3
		elif a.equals(r):
			return Vector2(a.low.x+(a.xsize/2),a.low.y)
		else:
			return Vector2(b.low.x,b.low.y+(b.ysize/2))
	elif a.low.x > b.low.x:
		# Case 4 - DOUBT
		if b.low.y == a.low.y && a.equals(r):
			return Vector2(a.low.x,a.low.y+(a.ysize/2))
		# Case 5
		elif a.low.y < b.low.y && a.equals(r):
			return Vector2(a.low.x,a.low.y+(a.ysize/2))
		# Case 6 - DOUBT
		elif a.equals(r):
			return Vector2(a.low.x+(a.xsize/2),a.low.y)
		else:
			return Vector2(b.low.x+(b.xsize/2),b.low.y)
	else:
		# Case 7
		if a.equals(r):
			return Vector2(a.low.x+(a.xsize/2),a.high.y)
		# Case 7
		else:
			return Vector2(a.low.x+(a.xsize/2),b.low.y)
		

# Sets interior of the edges of the tile map to a dark tile which is passable
# tm - TileMap to project on
# doorsClosed - Whether or not door closed tiles are created
func image_empty(tm:TileMap,doorsClosed:bool):
	if a.low.x < b.low.x:
		if a.low.y == b.low.y:
			print("Case 1")
			for i in range(a.high.x,b.low.x+1):
				if i == a.high.x || i == b.low.x:
					if doorsClosed:
						tm.set_cell(i,a.low.y+(a.ysize/2),5)
						tm.set_cell(i,a.low.y+(a.ysize/2)+1,6)
					else:
						tm.set_cell(i,a.low.y+(a.ysize/2),10)
						tm.set_cell(i,a.low.y+(a.ysize/2)+1,10)
				else:
					tm.set_cell(i,a.low.y+(a.ysize/2),2)
					tm.set_cell(i,a.low.y+(a.ysize/2)+1,11)
		elif a.low.y < b.low.y:
			print("Case 2")
			for i in range(a.low.x+(a.xsize/2),b.low.x+1):
				if i == b.low.x:
					if doorsClosed:
						tm.set_cell(i,b.low.y+(b.ysize/2),5)
						tm.set_cell(i,b.low.y+(b.ysize/2)+1,6)
					else:
						tm.set_cell(i,b.low.y+(b.ysize/2),10)
						tm.set_cell(i,b.low.y+(b.ysize/2)+1,10)
				else:
					tm.set_cell(i,b.low.y+(b.ysize/2),2)
					tm.set_cell(i,b.low.y+(b.ysize/2)+1,11)
			for i in range(a.high.y,b.low.y+(b.ysize/2)):
				if i == a.high.y:
					if doorsClosed:
						tm.set_cell(a.low.x+(a.xsize/2),i,7)
						tm.set_cell(a.low.x+(a.xsize/2)+1,i,8)
					else:
						tm.set_cell(a.low.x+(a.xsize/2),i,9)
						tm.set_cell(a.low.x+(a.xsize/2)+1,i,9)
				else:
					tm.set_cell(a.low.x+(a.xsize/2),i,2)
					tm.set_cell(a.low.x+(a.xsize/2)+1,i,11)
		elif a.low.y > b.low.y:
			print("Case 3")
			for i in range(a.low.x+(a.xsize/2),b.low.x+1):
				if i == b.low.x:
					if doorsClosed:
						tm.set_cell(i,b.low.y+(b.ysize/2),5)
						tm.set_cell(i,b.low.y+(b.ysize/2)+1,6)
					else:
						tm.set_cell(i,b.low.y+(b.ysize/2),10)
						tm.set_cell(i,b.low.y+(b.ysize/2)+1,10)
				else:
					tm.set_cell(i,b.low.y+(b.ysize/2),2)
					tm.set_cell(i,b.low.y+(b.ysize/2)+1,11)
			for i in range(b.low.y+(b.ysize/2),a.low.y+1):
				if i == a.low.y:
					if doorsClosed:
						tm.set_cell(a.low.x+(a.xsize/2),i,7)
						tm.set_cell(a.low.x+(a.xsize/2)+1,i,8)
					else:
						tm.set_cell(a.low.x+(a.xsize/2),i,9)
						tm.set_cell(a.low.x+(a.xsize/2)+1,i,9)
				else:
					tm.set_cell(a.low.x+(a.xsize/2),i,2)
					tm.set_cell(a.low.x+(a.xsize/2)+1,i,11)
		else:
			pass
	elif a.low.x > b.low.x:
		if b.low.y == a.low.y:
			pass
		elif a.low.y - b.low.y < 0:
			print("Case 5")
			for i in range(b.low.x+(b.xsize/2),a.low.x+1):
				if i == a.low.x:
					if doorsClosed:
						tm.set_cell(i,a.low.y+(a.ysize/2),5)
						tm.set_cell(i,a.low.y+(a.ysize/2)+1,6)
					else:
						tm.set_cell(i,a.low.y+(a.ysize/2),10)
						tm.set_cell(i,a.low.y+(a.ysize/2)+1,10)
				else:
					tm.set_cell(i,a.low.y+(a.ysize/2),2)
					tm.set_cell(i,a.low.y+(a.ysize/2)+1,11)
			for i in range(a.low.y+(a.ysize/2),b.low.y+1):
				if i == b.low.y:
					if doorsClosed:
						tm.set_cell(b.low.x+(b.xsize/2),i,7)
						tm.set_cell(b.low.x+(b.xsize/2)+1,i,8)
					else:
						tm.set_cell(b.low.x+(b.xsize/2),i,9)
						tm.set_cell(b.low.x+(b.xsize/2)+1,i,9)
				else:
					tm.set_cell(b.low.x+(b.xsize/2),i,2)
					tm.set_cell(b.low.x+(b.xsize/2)+1,i,11)
		elif a.low.y - b.low.y > 0:
			pass
	elif a.low.x == b.low.x:
		print("Case 7")
		if a.low.y < b.low.y:
			for i in range(a.high.y,b.low.y+1):
				if i == a.high.y || i == b.low.y:
					if doorsClosed:
						tm.set_cell(a.low.x+(a.xsize/2),i,7)
						tm.set_cell(a.low.x+(a.xsize/2)+1,i,8)
					else:
						tm.set_cell(a.low.x+(a.xsize/2),i,9)
						tm.set_cell(a.low.x+(a.xsize/2)+1,i,9)
				else:
					tm.set_cell(a.low.x+(a.xsize/2),i,2)
					tm.set_cell(a.low.x+(a.xsize/2)+1,i,11)
			

# Draws the walls of the edges to an impassable tile
# tm - TileMap to project on
func image_walls(tm:TileMap):
	if a.low.x > b.low.x:
		if a.low.y < b.low.y:
			for i in range(b.low.x+(b.xsize/2)-1,a.low.x+1):
				tm.set_cell(i,a.low.y+(a.ysize/2)+2,0)
				tm.set_cell(i,a.low.y+(a.ysize/2)-1,0)
			for i in range(a.low.y+(a.ysize/2)-1,b.low.y+1):
				tm.set_cell(b.low.x+(b.xsize/2)+2,i,0)
				tm.set_cell(b.low.x+(b.xsize/2)-1,i,0)
		return
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