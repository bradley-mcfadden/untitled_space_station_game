extends RigidBody2D
export var health:int
export var damage:int
export var movespeed:int
onready var spriteAnim:AnimatedSprite
onready var collisionShape:CollisionShape2D
class_name Enemy
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
