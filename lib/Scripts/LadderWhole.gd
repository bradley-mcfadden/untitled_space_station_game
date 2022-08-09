# Similar to Pusher Factory, but creates a ladder of specified length
# On entering the ladder, one can climb or descend it
extends Node2D
export var length:int


const LADDER_PIECE = preload("res://Scenes/Ladder.tscn")
onready var area = $Area2D
onready var segments:Array
signal ladder_entered()
signal ladder_exited()


# Init
func _ready():
	var rect:CollisionPolygon2D = area.get_child(0)
	rect.polygon = [Vector2(0, 0), Vector2(32, 0), Vector2(0, 32*length), Vector2(32, 32 * length)]
	$ColorRect.rect_size = Vector2(32,  32 * length)
	$ColorRect.rect_position += Vector2(16, 16)
	
	for i in range(length):
		var l1:Ladder = LADDER_PIECE.instance()
		l1.position = Vector2(16, 16 + (i * 32))
		segments.append(l1)
		add_child(l1)
	
	var x:Node2D = get_parent().get_parent().get_parent()
	x = x.get_node("Player")
	self.connect("ladder_entered", x, "_on_Ladder_Entered")
	self.connect("ladder_exited", x, "_on_Ladder_Exited")


# Handler for detecting if player has entered the ladder
#	body - Body that entered Area2D
func _on_Area2D_body_entered(body:PhysicsBody2D):
	if body is Player:
		emit_signal("ladder_entered")


# Handler for detecting if player has exited the ladder
#	body - Body that exited Area2D
func _on_Area2D_body_exited(body:PhysicsBody2D):
	if body is Player:
		emit_signal("ladder_exited")
