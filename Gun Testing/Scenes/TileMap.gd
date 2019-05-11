extends TileMap
class_name Dungeon

var Room = load("res://Scripts/Room.gd")
var shape = []
func _ready():
	randomize()
	#generate(0,0,50,50,3)
	update()
	
func generate(x,y,width,height,num):
	#shape.append(Room.new(Vector2(x,y),Vector2(x+width,y+height)))
	
	shape.append(Room.new(Vector2(x,y),Vector2(x+width,y+height)))   # seed output list
	while shape.size() <= num:
		for i in range(shape.size()):
    		shape = quadsect(shape[i], 3)
	for i in range(shape.size()):
		print(shape[i].to_string())


	

#import random
#from random import randint
#random.seed()
#
#NUM_RECTS = 20
#REGION = Rect(0, 0, 640, 480)
#
#class Rect(object):
#    def __init__(self, x1, y1, x2, y2):
#        minx, maxx = (x1,x2) if x1 < x2 else (x2,x1)
#        miny, maxy = (y1,y2) if y1 < y2 else (y2,y1)
#        self.min, self.max = Point(minx, miny), Point(maxx, maxy)
#
#    @staticmethod
#    def from_points(p1, p2):
#        return Rect(p1.x, p1.y, p2.x, p2.y)
#
#    width  = property(lambda self: self.max.x - self.min.x)
#    height = property(lambda self: self.max.y - self.min.y)
#
#plus_or_minus = lambda v: v * [-1, 1][(randint(0, 100) % 2)]  # equal chance +/-1
#
func quadsect(rect, factor):
	var w = rect.width
	var h = rect.height
	var center = Vector2()
	center.x = int(rect.minVal.x + int(w / 2))
	center.y = int(rect.minVal.y + int(h / 2))
	var delta_x = int(rand_range(-int(w/2), int(w/2)))
	var delta_y = int(rand_range(-int(h/2), int(h/2)))
	var interior = Vector2()
	interior.x = center.x + delta_x
	interior.y = center.y + delta_y
	
	return [Room.new(interior, Vector2(rect.minVal.x, rect.minVal.y)),
			Room.new(interior, Vector2(rect.maxVal.x, rect.minVal.y)),
			Room.new(interior, Vector2(rect.maxVal)),
			Room.new(interior, Vector2(rect.minVal))]

#def quadsect(rect, factor):
#    """ Subdivide given rectangle into four non-overlapping rectangles.
#        'factor' is an integer representing the proportion of the width or
#        height the deviatation from the center of the rectangle allowed.
#    """
#    # pick a point in the interior of given rectangle
#    w, h = rect.width, rect.height  # cache properties
#    center = Point(rect.min.x + (w // 2), rect.min.y + (h // 2))
#    delta_x = plus_or_minus(randint(0, w // factor))
#    delta_y = plus_or_minus(randint(0, h // factor))
#    interior = Point(center.x + delta_x, center.y + delta_y)
#
#    # create rectangles from the interior point and the corners of the outer one
#    return [Rect(interior.x, interior.y, rect.min.x, rect.min.y),
#            Rect(interior.x, interior.y, rect.max.x, rect.min.y),
#            Rect(interior.x, interior.y, rect.max.x, rect.max.y),
#            Rect(interior.x, interior.y, rect.min.x, rect.max.y)]
#
#def square_subregion(rect):
#    """ Return a square rectangle centered within the given rectangle """
#    w, h = rect.width, rect.height  # cache properties
#    if w < h:
#        offset = (h - w) // 2
#        return Rect(rect.min.x, rect.min.y+offset,
#                    rect.max.x, rect.min.y+offset+w)
#    else:
#        offset = (w - h) // 2
#        return Rect(rect.min.x+offset, rect.min.y,
#                    rect.min.x+offset+h, rect.max.y)
#
## call quadsect() until at least the number of rects wanted has been generated
#rects = [REGION]   # seed output list
#while len(rects) <= NUM_RECTS:
#    rects = [subrect for rect in rects
#                        for subrect in quadsect(rect, 3)]
#
#random.shuffle(rects)  # mix them up
#sample = random.sample(rects, NUM_RECTS)  # select the desired number
#print '%d out of the %d rectangles selected' % (NUM_RECTS, len(rects))
