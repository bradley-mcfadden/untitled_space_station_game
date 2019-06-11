extends KinematicBody2D
export var health:int
export var damage:int
export var movespeed:int
signal hit(damage)
const GRAVITY = 450
export var direction = -1
onready var velocity:Vector2
onready var spriteAnim:AnimatedSprite
onready var collisionShape:CollisionShape2D
onready var frontCast:RayCast2D
onready var backCast:RayCast2D
onready var frontFloorCast:RayCast2D
onready var backFloorCast:RayCast2D
class_name Enemy

# Init
func _ready():
	pass

# Setter for health, and handles knockback
#	dmg - Amount of damage to take
#	normal - Direction damage is coming from	
func take_damage(dmg:int, normal:Vector2):
	health -= dmg
	if health <= 0:
		# print("I have died")
		queue_free()
	move_and_slide(normal,Vector2(0,-1))

# Called every frame. 'delta' is the elapsed time since the previous frame.
#	delta - Time since last frame
func _process(delta):
	pass
