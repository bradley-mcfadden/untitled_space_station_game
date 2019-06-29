# when player is not in room, get rid of damping 
extends KinematicBody2D
class_name Player
export var movespeed:float
var speedCap
const GRAVITY = 450
const STARTING_HEALTH = 100
var max_health = 100
const ROOM_JUMP = 350
const EDGE_JUMP = 450
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
onready var hitShield = false
onready var direction = 1
onready var linearDamping = 0.90
onready var jumpPower = 350
onready var items = []
onready var HUD
onready var damageMultiplier 
# onready var movespeedMultiplier
#class_name Player

# Init
func _ready():
	start(Vector2(0,0))
	HUD = $HUD

# Reset player position on death	
#	startPosition - Location player starts on respawn
func start(startPosition:Vector2):
	speedCap = 200
	movespeed = 24
	damageMultiplier = 1
	coins = 0
	jumping = false
	hitShield = false
	self.position = startPosition
	max_health = STARTING_HEALTH
	health = max_health
	$HUD.health_update(health)
	$DamageTimer.start()
	$Shotgun.craft()
	
# Handles input and movement of player
#	delta - Time since last frame
func _physics_process(delta):
	if health > 0:
		if (!is_on_floor()):
			velocity.y += delta * GRAVITY
		if (is_on_floor() and Input.is_action_pressed("ui_up")):
			velocity.y = -jumpPower*1.15
		if (Input.is_action_pressed("ui_left") and velocity.x-movespeed > -speedCap):
			velocity.x -= movespeed
			$AnimatedSprite.play("walk")
		elif (Input.is_action_pressed("ui_right") and velocity.x+movespeed < speedCap):
			velocity.x += movespeed
			$AnimatedSprite.play("walk")
		else:
			velocity.x *= linearDamping
		if velocity.x == 0:
			$AnimatedSprite.play("idle")
		elif abs(velocity.x) < 10:
			velocity.x = 0
		else:
			get_parent().update_tiles()
		if (Input.is_action_pressed("ui_down")):
			pass
		if (Input.is_action_just_released("ui_x")):
			rotate_gun_list()
			#velocity.y += 1
		# velocity *= movespeedMultiplier
		velocity = move_and_slide(velocity,Vector2(0,-1))
		#position += velocity * delta
		#position.x = clamp(position.x, 8, screen_size.x-20)
		#position.y = clamp(position.y, 12, screen_size.y-20)
		var norm = get_global_mouse_position() - self.position
		#look_at(get_global_mouse_position())
		norm = norm.normalized()
		var rot = atan2(norm.y, norm.x)
		if rot > -PI/2 && rot < PI/2:
			$AnimatedSprite.flip_h = false
			direction = 1
		else:
			$AnimatedSprite.flip_h = true
			direction = -1

# Switches between absolute roster of guns,
# for testing purposes
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

# Updates player health and HUD
#	damage - Amount of damage to take
#	norm - Direction of incoming damage
func take_damage(damage:int, norm:Vector2):
	if !hitShield:
		hitShield = true
		$DamageTimer.start()
		if health - damage <= 0:
			hitShield = true
			health = 0
			get_parent().game_over()
			$HUD/DeathLabel.visible = true
			$HUD/RestartButton.visible = true
			
		else:
			health -= damage
		$HUD.health_update(health)
		move_and_slide(norm)

# Event handler for expiry of damage timer
func _on_DamageTimer_timeout():
	hitShield = false

# Toggles linear damping on or off and increases jump power when damping is off
func toggle_damping():
	if linearDamping == 1:
		linearDamping = 0.9
	else:
		linearDamping = 1
	if jumpPower == EDGE_JUMP:
		jumpPower = ROOM_JUMP
	else:
		jumpPower = EDGE_JUMP 
	# print("called"," ",linearDamping," ",jumpPower)

func add_item(i:Item):
	i.effect(self)
	items.append(i)
	$HUD.add_item(i)