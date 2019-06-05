extends Node
class_name PusherFactory
onready var tm:TileMap
onready var ef:TileMap
onready var tmps:Vector2
onready var pushers = []
onready var dir:Vector2
# Called when the node enters the scene tree for the first time.
func _ready():
	tm = get_parent()
	ef = tm.Effects
	while flood():
		pass
	
func flood() -> bool:
	var success = false
	var newPos:Vector2
	if pushers.size() == 0:
		newPos = tmps
	else:
		newPos = tm.world_to_map(pushers[pushers.size()-1].position)
	if ef.get_cellv(newPos+dir) == -1 and tm.get_cellv(newPos+dir) == 2:
		if dir.x != 0:
			ef.set_cell(newPos.x+dir.x,newPos.y+dir.y,0)
		else:
			ef.set_cell(newPos.x+dir.x,newPos.y+dir.y,1)
		var pPos = tm.map_to_world(newPos+dir)
		var push = Pusher.instance()
		push.create(pPos,dir)
		pushers.add(push)
		add_child(push,true)
		success = true
	var normal = Vector2(dir.y,dir.x)
	if ef.get_cellv(newPos+normal) == -1 and tm.get_cellv(newPos+normal) == 2:
		if dir.x != 0:
			ef.set_cell(newPos.x+normal.x,newPos.y+normal.y,0)
		else:
			ef.set_cell(newPos.x+normal.x,newPos.y+normal.y,1)
		var pPos = tm.map_to_world(newPos+normal)
		var push = Pusher.instance()
		push.create(pPos,normal)
		pushers.add(push)
		add_child(push,true)
		success = true
	normal *= -1
	if ef.get_cellv(newPos+normal) == -1 and tm.get_cellv(newPos+normal) == 2:
		if dir.x != 0:
			ef.set_cell(newPos.x+normal.x,newPos.y+normal.y,0)
		else:
			ef.set_cell(newPos.x+normal.x,newPos.y+normal.y,1)
		var pPos = tm.map_to_world(newPos+normal)
		var push = Pusher.instance()
		push.create(pPos,normal)
		pushers.add(push)
		add_child(push,true)
		success = true
	dir = pushers[pushers.size()-1].dir
	return success
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
