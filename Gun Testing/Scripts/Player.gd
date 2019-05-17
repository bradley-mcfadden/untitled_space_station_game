extends KinematicBody2D
export var movespeed = 24
const JUMP_POWER = 300
const GRAVITY = 450
var screen_size 
var velocity = Vector2()
var jumping = false
var SMG = preload("res://Scripts/TileMap.gd")
var Shotgun = preload("res://Scripts/Shotgun.gd")
var Pistol = preload("res://Scripts/Pistol.gd")
var gunList = [SMG,Shotgun,Pistol]

func _ready():
	screen_size = get_viewport_rect().size
	
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
		#velocity.y += 1
	move_and_slide(velocity, Vector2(0, -1))
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
			cGun = Gun
	var cPos
	for i in range(gunList.size()):
		if cGun is gunList[i]:
			cPos = i
			gunList[i].queue_free()
	if cPos == gunList.size()-1:
		add_child(gunList[0].new())
	else:
		add_child(gunList[cPos+1].new())