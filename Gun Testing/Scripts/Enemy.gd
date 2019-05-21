extends KinematicBody2D
export var health:int
export var damage:int
export var movespeed:int
signal hit(damage)
onready var spriteAnim:AnimatedSprite
onready var collisionShape:CollisionShape2D
onready var frontCast:RayCast2D
onready var backCast:RayCast2D
onready var frontFloorCast:RayCast2D
onready var backFloorCast:RayCast2D
class_name Enemy
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	
func take_damage(dmg:int):
	health -= dmg
	if health <= 0:
		print("I have died")
		queue_free()
	print("Me has taken damage"+str(health))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
