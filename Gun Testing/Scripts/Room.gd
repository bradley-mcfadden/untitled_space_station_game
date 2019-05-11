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
extends Object
class_name Room
var maxVal
var minVal
var width
var height
	
func _init(p1, p2):
	minVal = Vector2()
	maxVal = Vector2()
	minVal.x = p1.x if p1.x < p2.x else p2.x
	minVal.y = p1.y if p1.y < p2.y else p2.y
	maxVal.x = p2.x if p2.x > p1.x else p1.x
	maxVal.y = p2.y if p2.y > p1.y else p1.x
	width = maxVal.x - minVal.x
	height = maxVal.y - minVal.y
	
func to_string():
	return str(maxVal, " ", minVal, " ", width, " ", height, " ")