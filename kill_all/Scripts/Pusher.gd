# A Pusher detects movement from KinematicBody and will slide
# these bodies along its direction
extends Area2D
class_name Pusher

onready var dir:Vector2
const SPEED = 100

# Init
func _ready():
	pass

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
		body.velocity += dir * SPEED
