extends KinematicBody2D
class_name Player

const GRAVITY = 10
const STARTING_HEALTH = 100
const ROOM_JUMP = 420
const EDGE_JUMP = 450
var maxHealth = STARTING_HEALTH
onready var movespeed
onready var velocity:Vector2
onready var jumping:bool
onready var SMG = load("res://Guns/GunScripts/SMG.gd")
onready var Shotgun = load("res://Guns/GunScripts/Shotgun.gd")
onready var Pistol = load("res://Guns/GunScripts/Pistol.gd")
onready var gunList = [SMG,Shotgun,Pistol]
onready var gunRef = [load("res://Guns/SMG.tscn"),
					  load("res://Guns/Shotgun.tscn"),
					  load("res://Guns/Pistol.tscn")]
onready var gunInventory
onready var speedCap
onready var coins:int
onready var health:int 
onready var hitShield:bool
onready var direction
onready var linearDamping
onready var jumpPower
onready var items = []
onready var HUD
onready var accumSpeed
onready var onLadder
onready var Anim:AnimatedSprite
onready var currentGun
onready var running:bool
onready var DamageTimer:Timer
onready var veganPower:bool

# Init
func _ready():
	start(Vector2(0,0))
	HUD = $HUD
	DamageTimer = $DamageTimer

# Reset player position on death	
#	startPosition - Location player starts on respawn
func start(startPosition:Vector2):
	veganPower = false
	gunInventory = []
	Anim = $AnimatedSprite
	direction = 1
	linearDamping = 0.90
	jumpPower = ROOM_JUMP
	velocity = Vector2()
	running = false
	onLadder = false
	accumSpeed = 0
	speedCap = 200
	movespeed = 24
	PlayerVariables.damageMultiplier = 1
	coins = 0
	jumping = false
	hitShield = false
	self.position = startPosition
	maxHealth = STARTING_HEALTH
	health = maxHealth
	$HUD.health_update(health)
	$DamageTimer.wait_time = 0.5
	$DamageTimer.start()
	$Shotgun.craft()
	currentGun = $Shotgun
	gunInventory.append(currentGun)
	
# Handles non-movement related input 
#	delta - Time since last frame
func _process(delta):
	if health <= 0:
		return
	if (Input.is_action_just_released("ui_x")):
		rotate_gun_list()	
		
	var norm = get_global_mouse_position() - self.position
	norm = norm.normalized()
	
	var rot = atan2(norm.y, norm.x)
	if rot > -PI/2 && rot < PI/2:
		$AnimatedSprite.flip_h = false
		direction = 1
	else:
		$AnimatedSprite.flip_h = true
		direction = -1	
	
# Handles movement of player and input
#	delta - Time since last frame
func _physics_process(delta):
	if health <= 0:
		return
	if !onLadder:
		if !is_on_floor():
			accumSpeed += 0.5
			velocity.y += GRAVITY + accumSpeed
		elif Input.is_action_pressed("ui_up"):
			velocity.y = -jumpPower * PlayerVariables.jumpMultiplier * 1.15
			accumSpeed = 0
		if Input.is_action_pressed("ui_lmbd") and !running:
			currentGun.fire_gun()
		if velocity.x == 0:
			$AnimatedSprite.play("idle")
		elif abs(velocity.x) < 10:
			velocity.x = 0
		else:
			$AnimatedSprite.play("walk")
		get_parent().update_tiles()
		
	elif onLadder:
		velocity.y = 0
		if Input.is_action_pressed("ui_up"):
			velocity.y -= 96
			$AnimatedSprite.play("climb")
		elif Input.is_action_pressed("ui_down"):
			velocity.y += 96
			$AnimatedSprite.play("climb")
		else:
			$AnimatedSprite.play("climb_idle")
			
	if Input.is_action_pressed("ui_shift"):
		if onLadder:
			pass
		else:
			if abs(velocity.x)+movespeed < speedCap * 2:
				if Input.is_action_pressed("ui_left"):
					velocity.x -= movespeed * 1.5
				elif Input.is_action_pressed("ui_right"):
					velocity.x += movespeed * 1.5
				else:
					velocity.x *= linearDamping
			running = true 
			currentGun.visible = false
	elif Input.is_action_just_released("ui_shift"):
		if onLadder:
			pass
		else:
			running = false
			currentGun.visible = true
	else:
		if abs(velocity.x)+movespeed < speedCap:
			if Input.is_action_pressed("ui_left"):
				velocity.x -= movespeed
			elif Input.is_action_pressed("ui_right"):
				velocity.x += movespeed
			else:
				velocity.x *= linearDamping
	velocity.x *= linearDamping
	velocity = move_and_slide(velocity,Vector2(0,-1))

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
	# print("CPOS"+str(cPos))
	var tempGun
	if cPos == gunList.size()-1:
		tempGun = gunRef[0].instance()
	else:
		tempGun = gunRef[cPos+1].instance()
	add_child(tempGun)
	currentGun = tempGun

# Updates player health and HUD
#	damage - Amount of damage to take
#	norm - Direction of incoming damage
func take_damage(damage:int, norm:Vector2):
	if hitShield:
		return
	if veganPower:
		PlayerVariables.damageMultiplier *= 2
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
	velocity = move_and_slide(norm)

# Event handler for expiry of damage timer
func _on_DamageTimer_timeout():
	hitShield = false
	if veganPower:
		PlayerVariables.damageMultiplier /= 2

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

# Add an item to the HUD's inventory
# i - Item to add
func add_item(i:Item):
	i.effect(self)
	items.append(i)
	$HUD.add_item(i)
	
# Event handler for when a player enters a ladder.
func _on_Ladder_Entered():
	onLadder = true
	Anim.play("climb")
	currentGun.visible = false
	# print(Player.onLadder)

# Handler for when player exits a ladder.
func _on_Ladder_Exited():
	running = false
	onLadder = false
	currentGun.visible = true

# Add health to player
func _on_RegenTimer_Timeout():
	health += 1
	if health > maxHealth:
		health = maxHealth
	HUD.health_update(health,0)