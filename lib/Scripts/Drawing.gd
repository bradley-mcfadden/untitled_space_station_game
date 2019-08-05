extends Node2D
const MAP_LOCATION = Vector2(50, 200)

func _draw():
	draw_rect(Rect2(MAP_LOCATION, Vector2(5, 5) + get_parent().highest_corner - get_parent().lowest_corner), 
			Color(255, 255, 255, 0.2))
	for edge in get_parent().world.edge_set.data:
		draw_line(Vector2(edge.a.low.x + edge.a.xsize/2, edge.a.low.y + edge.a.ysize / 2) + MAP_LOCATION 
				- get_parent().lowest_corner, 
				Vector2(edge.b.low.x + edge.b.xsize/2, edge.b.low.y + edge.b.ysize / 2) + MAP_LOCATION 
				- get_parent().lowest_corner, Color(0, 0, 0, 1))
	for room in get_parent().world.visited_rooms.data:
		draw_rect(rect_to_rect2(room), Color(255, 0, 0, 1))
		if room.equals(get_parent().world.find_player(get_parent().get_parent().player.position)):
			draw_rect(rect_to_rect2(room), Color(0, 0, 0, 1))
	update()


func rect_to_rect2(rect:Rect):
	return Rect2(MAP_LOCATION.x + rect.low.x - get_parent().lowest_corner.x, 
			MAP_LOCATION.y + rect.low.y - get_parent().lowest_corner.y, 
			rect.xsize, rect.ysize)