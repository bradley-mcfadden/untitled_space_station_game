extends KinematicBody2D
class_name Player

export var movespeed = 24
const JUMP_POWER = 300
const GRAVITY = 450
const MAX_HEALTH = 100
onready var screen_size 
onready var velocity = Vector2()
onready var jumping = false
onready var SMG = load("res://Scripts/SMG.gd")
onready var Shotgun = load("res://Scripts/Shotgun.gd")
onready var Pistol = load("res://Scripts/Pistol.gd")
onready var gunList = [SMG,Shotgun,Pistol]
onready var gunRef = [load("res://Scenes/SMG.tscn"),
					  load("res://Scenes/Shotgun.tscn"),
					  load("res://Scenes/Pistol.tscn")]
onready var coins:int
onready var health:int 
#class_name Player

func _ready():
	screen_size = get_viewport_rect().size
	coins = 0
	health = MAX_HEALTH
	
func _physics_process(delta):
	if (!is_on_floor()):
		velocity.y += delta * GRAVITY
	if (Input.is_action_pressed("ui_left") and velocity.x-movespeed > -200):
		velocity.x -= movespeed
		$AnimatedSprite.play("walk")
	elif (Input.is_action_pressed("ui_right") and velocity.x+movespeed < 200):
		velocity.x += movespeed
		$AnimatedSprite.play("walk")
	else:
		velocity.x *= 0.90
	if velocity.x == 0:
		$AnimatedSprite.play("idle")
	elif abs(velocity.x) < 10:
		velocity.x = 0
	if (is_on_floor() and Input.is_action_just_pressed("ui_up")):
		velocity.y = -JUMP_POWER*1.15
		#velocity.y += -1
	if (Input.is_action_pressed("ui_down")):
		pass
	if (Input.is_action_just_released("ui_x")):
		rotate_gun_list()
		#velocity.y += 1
	velocity = move_and_slide(velocity, Vector2(0, -1))
	#position += velocity * delta
	#position.x = clamp(position.x, 8, screen_size.x-20)
	#position.y = clamp(position.y, 12, screen_size.y-20)
	var norm = get_global_mouse_position() - self.position
	#look_at(get_global_mouse_position())
	norm = norm.normalized()
	var rot = atan2(norm.y, norm.x)
	if rot > -PI/2 && rot < PI/2:
		$AnimatedSprite.flip_h = false
	else:
		$AnimatedSprite.flip_h = true

func rotate_gun_list():
	var cGun 
	for child in get_children():
		if child is Gun:
			cGun = child
	var cPos = 0
	for i in range(gunList.size()):
		if cGun is gunList[i]:
			cPos = i
			cGun.queue_free()
	print("CPOS"+str(cPos))
	var tempGun
	if cPos == gunList.size()-1:
		tempGun = gunRef[0].instance()
	else:
		tempGun = gunRef[cPos+1].instance()
	add_child(tempGun)

func _on_take_Damage(damage:int):
	if health - damage <= 0:
		health = 0
	else:
		health -= damage
	$HUD.healthUpdate(health)