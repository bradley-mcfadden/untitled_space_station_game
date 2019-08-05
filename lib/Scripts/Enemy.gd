extends KinematicBody2D
class_name Enemy


export var health:int
export var damage:int
export var movespeed:int
export var value:int
export var direction:int = -1
signal hit(damage)
signal dropped_coins(position, num_coins)
const GRAVITY = 450
onready var sprite_anim:AnimatedSprite
onready var collision_shape:CollisionShape2D
onready var front_cast:RayCast2D
onready var back_cast:RayCast2D
onready var front_floor_cast:RayCast2D
onready var back_floor_cast:RayCast2D
onready var frozen:bool
onready var stasis_velocity:Vector2
onready var velocity:Vector2


# Init
func _ready():
	connect("dropped_coins", get_parent().get_parent().get_parent().get_parent(), "_on_Drop_Coins")
	material = get_parent().material
	frozen = false


# Setter for health, and handles knockback
#	dmg - Amount of damage to take
#	normal - Direction damage is coming from	
func take_damage(dmg:int, normal:Vector2):
	health -= dmg
	# If I'm dead
	if health <= 0:
		collision_shape.disabled = true
		get_parent().num_enemies -= 1
		emit_signal("dropped_coins", global_position, int(rand_range(value - 2, value + 2)))
		# If there are no other enemies,
		# then mark the room as cleared, 
		# unlock the world.
		if get_parent().num_enemies <= 0:
			get_parent().get_parent().cleared = true
			get_parent().get_parent().get_parent().lock = false
		queue_free()
	if frozen == true:
		stasis_velocity += normal
		return
	move_and_slide(normal, Vector2(0, -1))


func end_stasis():
	velocity = move_and_slide(stasis_velocity, Vector2(0, -1))
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
#	delta - Time since last frame
func _process(delta:float):
	pass
