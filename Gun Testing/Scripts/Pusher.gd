extends Area2D
class_name Pusher
onready var dir:Vector2
onready var tmps:Vector2
const SPEED = 50

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Set the position and direction of the pusher
#	ps - TileMap position of this pusher
#	dir - Direction objects will be pushed
func create(ps:Vector2,dir:Vector2):
	self.position = ps
	self.dir = dir

# Called when a body enters the pusher
#	body - Body to push
func _on_Pusher_body_entered(body):
	if body is KinematicBody2D:
		body.velocity = body.move_and_slide(dir*SPEED)
