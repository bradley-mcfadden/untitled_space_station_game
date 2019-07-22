extends KinematicBody2D
class_name Player
const GRAVITY = 12
const STARTING_HEALTH = 100
const ROOM_JUMP = 430
const EDGE_JUMP = 450
var maxHealth = STARTING_HEALTH
onready var movespeed
onready var velocity:Vector2
onready var jumping:bool
onready var gunInventory:GunInventory
onready var completeInventory:GunInventory
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
onready var activeItem:ActiveItem
onready var running:bool
onready var DamageTimer:Timer
onready var veganPower:bool
onready var ironSkin:bool
onready var potentialPurchase

# Init
func _ready():
	start(Vector2(0,0))
	HUD = $HUD
	DamageTimer = $DamageTimer

# Reset player position on death	
#	startPosition - Location player starts on respawn
func start(startPosition:Vector2):
	activeItem = null
	veganPower = false
	gunInventory = GunInventory.new()
	completeInventory = GunInventory.new()
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
	currentGun = $Pistol
	gunInventory.add(currentGun)
	completeInventory.add(currentGun)
	for gun in GlobalVariables.gunRef:
		completeInventory.add(gun.instance())
	
# Handles non-movement related input 
#	delta - Time since last frame
func _process(delta):
	if health <= 0:
		return

	if Input.is_action_just_pressed("use_item") && activeItem != null:
		activeItem.active_effect()
		activeItem.isReady = false
		$CDTimer.start()
		HUD.get_node("ActiveItem").inverted = true
		HUD.get_node("CDTimer").start()
	
	if ((Input.is_action_just_pressed("reload") && currentGun.currentDurability > 0) 
    && currentGun.ReloadTimer.paused == false):
		currentGun.ReloadTimer.start()
		
	if Input.is_action_just_released("ui_x"):
		rotate_gun_list()	
		HUD._on_weapon_swap(currentGun)
		
	if Input.is_action_just_pressed("switch_guns"):
		remove_child(currentGun)
		currentGun = gunInventory.swap_current()
		add_child(currentGun)
		HUD._on_weapon_swap(currentGun)
		
	if Input.is_action_just_pressed("ui_e") and potentialPurchase != null:
		if coins >= potentialPurchase.cost:
			coins -= potentialPurchase.cost
			potentialPurchase.purchased = true
			HUD.fading_message("Picked up '"+potentialPurchase.item.title+"'.")
			HUD.coin_update(coins)
			if potentialPurchase.item is Item:
				add_item(potentialPurchase.item)
			elif potentialPurchase.item is Gun:
				gunInventory.add(potentialPurchase.item)
				remove_child(currentGun)
				currentGun = gunInventory.swap_current()
				add_child(currentGun)
				HUD._on_weapon_swap(currentGun)
			elif potentialPurchase.item is ActiveItem:
				if activeItem != null:
					var drop = load("res://Scenes/Pickup.tscn").instance()
					drop.item = activeItem
					drop.global_position = global_position
					get_parent().add_child(drop)
				activeItem = potentialPurchase.item
				$CDTimer.wait_time = potentialPurchase.item.cooldown
				HUD.active_item_swtich(potentialPurchase.item)
			potentialPurchase.queue_free()
			potentialPurchase = null
		else:
			HUD.set_message_text("Insufficient funds")
		
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
#warning-ignore:unused_argument
func _physics_process(delta):
	if health <= 0:
		return
	if !onLadder:
		if !is_on_floor():
			if accumSpeed < 5:
				accumSpeed += 0.5
			velocity.y += GRAVITY + accumSpeed
		elif Input.is_action_pressed("ui_up"):
			velocity.y = -jumpPower * PlayerVariables.jumpMultiplier * 1.15
			accumSpeed = 0
		if Input.is_action_pressed("ui_lmbd") and !running and currentGun != null:
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
	remove_child(currentGun)
	currentGun = completeInventory.swap_current()
	add_child(currentGun)
	currentGun.currentDurability = currentGun.clipSize * 100
	currentGun.on_ReloadTimer_timeout()

# Updates player health and HUD
#	damage - Amount of damage to take
#	norm - Direction of incoming damage
func take_damage(damage:int, norm:Vector2):
	if hitShield || ironSkin:
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

# Returns a vector of the force that the player should exert on a body
#	body - Body to determine gravity force 
#	return - Gravity force between player and body
func pull(body:Node2D) -> Vector2:
	var force:Vector2 = global_position - body.global_position
	var distance = force.length()
	distance = clamp(distance,1,70)
	force = force.normalized()
	var strength = 50000 / (distance*distance)
	force *= strength
	return force

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

# Allow item to be used again, and stop the looping timer.
func _on_CDTimer_timeout():
	activeItem.isReady = true
	HUD.get_node("ActiveItem").invert_enable = false
	HUD.get_node("CDTimer").stop()
	HUD.get_node("CDText").text = ""