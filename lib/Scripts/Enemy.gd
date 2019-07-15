extends KinematicBody2D
export var health:int
export var damage:int
export var movespeed:int
export var value:int
signal hit(damage)
signal drop_coins(position,num_coins)
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
	connect("drop_coins",get_parent().get_parent().get_parent().get_parent(),"_on_Drop_Coins")

# Setter for health, and handles knockback
#	dmg - Amount of damage to take
#	normal - Direction damage is coming from	
func take_damage(dmg:int, normal:Vector2):
	health -= dmg
	# If I'm dead
	if health <= 0:
		collisionShape.disabled = true
		get_parent().numEnemies -= 1
		emit_signal("drop_coins",global_position,int(rand_range(value-2,value+2)))
		# If there are no other enemies,
		# then mark the room as cleared, 
		# unlock the world.
		if get_parent().numEnemies <= 0:
			get_parent().get_parent().cleared = true
			get_parent().get_parent().get_parent().lock = false
		queue_free()
	move_and_slide(normal,Vector2(0,-1))

# Called every frame. 'delta' is the elapsed time since the previous frame.
#	delta - Time since last frame
func _process(delta):
	pass
