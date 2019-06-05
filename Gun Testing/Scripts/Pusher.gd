extends Area2D
class_name Pusher
onready var dir:Vector2
onready var tmps:Vector2
const SPEED = 50

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func create(ps:Vector2,dir:Vector2):
	self.position = ps
	self.dir = dir

func _on_Pusher_body_entered(body):
	if body is KinematicBody2D:
		body.velocity = body.move_and_slide(dir*SPEED)
