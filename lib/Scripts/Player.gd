extends KinematicBody2D
class_name Player


const GRAVITY = 12
const STARTING_HEALTH = 100
const ROOM_JUMP = 495
const EDGE_JUMP = 518
var max_health:int = STARTING_HEALTH
onready var movespeed:float
onready var velocity:Vector2
onready var jumping:bool
onready var gun_inventory:GunInventory
onready var complete_inventory:GunInventory
onready var speed_cap:float
onready var coins:int
onready var health:int 
onready var has_hit_shield:bool
onready var direction:int
onready var horizontal_damping:float
onready var jump_power:float
onready var items:Array = []
onready var hud:CanvasLayer
onready var terminal_velocity:int
onready var is_on_ladder:bool
onready var animated_sprite:AnimatedSprite
onready var equipped_gun:Gun
onready var active_item:ActiveItem
onready var running:bool
onready var damage_timer:Timer
onready var has_vegan_power:bool
onready var has_iron_skin:bool
onready var potential_purchase:Pickup


# Init
func _ready():
	start(Vector2(0, 0))
	hud = $HUD
	damage_timer = $DamageTimer
	animated_sprite = $AnimatedSprite


# Reset player position on death	
#	start_position - Location player starts on respawn
func start(start_position:Vector2):
	active_item = null
	has_vegan_power = false
	gun_inventory = GunInventory.new()
	complete_inventory = GunInventory.new()
	direction = 1
	horizontal_damping = 0.90
	jump_power = ROOM_JUMP
	velocity = Vector2()
	running = false
	is_on_ladder = false
	terminal_velocity = 0
	speed_cap = 200
	movespeed = 24
	coins = 0
	jumping = false
	has_hit_shield = false
	position = start_position
	max_health = STARTING_HEALTH
	health = max_health
	$HUD.health_update(health)
	$DamageTimer.wait_time = 0.5
	$DamageTimer.start()
	equipped_gun = $Pistol
	gun_inventory.add(equipped_gun)
	complete_inventory.add(equipped_gun)
	for gun in GlobalVariables.GUNREF:
		complete_inventory.add(gun.instance())


# Handles non-movement related input 
#	delta - Time since last frame
func _process(delta:float):
	if health <= 0:
		return

	if Input.is_action_just_pressed("use_item") && active_item != null:
		if active_item.is_ready == true:
			active_item.active_effect()
			active_item.is_ready = false
			$EffectTimer.start()
			hud.get_node("ActiveItem").invert_enable = false
	
	if ((Input.is_action_just_pressed("reload") && equipped_gun.current_durability > 0) 
    && equipped_gun.reload_timer.paused == false):
		equipped_gun.reload_timer.start()
		
	if Input.is_action_just_released("ui_x"):
		rotate_gun_list()	
		hud._on_weapon_swap(equipped_gun)
		
	if Input.is_action_just_pressed("switch_guns"):
		remove_child(equipped_gun)
		equipped_gun = gun_inventory.swap_current()
		add_child(equipped_gun)
		hud._on_weapon_swap(equipped_gun)
		
	if Input.is_action_just_pressed("ui_e") and potential_purchase != null:
		if coins >= potential_purchase.cost:
			coins -= potential_purchase.cost
			potential_purchase.purchased = true
			hud.fading_message("Picked up '" + potential_purchase.item.title + "'.")
			hud.coin_update(coins)
			if potential_purchase.item is Item:
				add_item(potential_purchase.item)
			elif potential_purchase.item is Gun:
				gun_inventory.add(potential_purchase.item)
				remove_child(equipped_gun)
				equipped_gun = gun_inventory.swap_current()
				add_child(equipped_gun)
				hud._on_weapon_swap(equipped_gun)
			elif potential_purchase.item is ActiveItem:
				if active_item != null:
					var drop:Pickup = load("res://Scenes/Pickup.tscn").instance()
					drop.item = active_item
					drop.global_position = global_position
					get_parent().add_child(drop)
				add_active_item(potential_purchase.item)
			potential_purchase.queue_free()
			potential_purchase = null
		else:
			hud.set_message_text("Insufficient funds")
		
	var norm:Vector2 = get_global_mouse_position() - self.position
	norm = norm.normalized()
	
	var mouse_tangent:float = atan2(norm.y, norm.x)
	if mouse_tangent > -PI / 2 && mouse_tangent < PI / 2:
		animated_sprite.flip_h = false
		direction = 1
	else:
		animated_sprite.flip_h = true
		direction = -1	


# Handles movement of player and input
#	delta - Time since last frame
#warning-ignore:unused_argument
func _physics_process(delta:float):
	if health <= 0:
		return
	if !is_on_ladder:
		if !is_on_floor():
			if terminal_velocity < 5:
				terminal_velocity += 0.5
			velocity.y += GRAVITY + terminal_velocity
		elif Input.is_action_pressed("ui_up"):
			velocity.y = -jump_power * PlayerVariables.jump_multiplier
			terminal_velocity = 0
		if Input.is_action_pressed("ui_lmbd") && !running && equipped_gun != null:
			equipped_gun.fire_gun()
		if velocity.x == 0:
			animated_sprite.play("idle")
		elif abs(velocity.x) < 10:
			velocity.x = 0
		else:
			animated_sprite.play("walk")
		get_parent().update_tiles()
		
	elif is_on_ladder:
		velocity.y = 0
		if Input.is_action_pressed("ui_up"):
			velocity.y -= 96
			animated_sprite.play("climb")
		elif Input.is_action_pressed("ui_down"):
			velocity.y += 96
			animated_sprite.play("climb")
		else:
			animated_sprite.play("climb_idle")
			
	if Input.is_action_pressed("ui_shift"):
		if is_on_ladder:
			pass
		else:
			if abs(velocity.x) + movespeed < speed_cap * 2:
				if Input.is_action_pressed("ui_left"):
					velocity.x -= movespeed * 1.5
				elif Input.is_action_pressed("ui_right"):
					velocity.x += movespeed * 1.5
				else:
					velocity.x *= horizontal_damping
			running = true 
			equipped_gun.visible = false
	elif Input.is_action_just_released("ui_shift"):
		if is_on_ladder:
			pass
		else:
			running = false
			equipped_gun.visible = true
	else:
		if abs(velocity.x)+movespeed < speed_cap:
			if Input.is_action_pressed("ui_left"):
				velocity.x -= movespeed
			elif Input.is_action_pressed("ui_right"):
				velocity.x += movespeed
			else:
				velocity.x *= horizontal_damping
	velocity.x *= horizontal_damping
	velocity = move_and_slide(velocity, Vector2(0, -1))


# Switches between absolute roster of guns,
# for testing purposes
func rotate_gun_list():
	remove_child(equipped_gun)
	equipped_gun = complete_inventory.swap_current()
	add_child(equipped_gun)
	equipped_gun.current_durability = equipped_gun.clip_size * 100
	equipped_gun.on_ReloadTimer_timeout()


# Updates player health and hud
#	damage - Amount of damage to take
#	norm - Direction of incoming damage
func take_damage(damage:int, norm:Vector2):
	if has_hit_shield || has_iron_skin:
		return
	if has_vegan_power:
		PlayerVariables.damage_multiplier *= 2
	has_hit_shield = true
	damage_timer.start()
	if health - damage <= 0:
		has_hit_shield = true
		health = 0
		get_parent().game_over()
		$HUD/DeathLabel.visible = true
		$HUD/RestartButton.visible = true
		
	else:
		health -= damage
	hud.health_update(health)
	velocity = move_and_slide(norm)


# Event handler for expiry of damage timer
func _on_DamageTimer_timeout():
	has_hit_shield = false
	if has_vegan_power:
		PlayerVariables.damage_multiplier /= 2


# Toggles linear damping on or off and increases jump power when damping is off
func toggle_damping():
	if horizontal_damping == 1:
		horizontal_damping = 0.9
	else:
		horizontal_damping = 1
	if jump_power == EDGE_JUMP:
		jump_power = ROOM_JUMP
	else:
		jump_power = EDGE_JUMP 
	# print("called"," ",horizontal_damping," ",jump_power)


# Add an item to the HUD's inventory
# i - Item to add
func add_item(i:Item):
	i.effect(self)
	items.append(i)
	hud.add_item(i)


# Handles adding active items to player inventory
#	ai - Active Item to add
func add_active_item(ai:ActiveItem):
	active_item = ai
	$CDTimer.wait_time = ai.cooldown
	hud.active_item_switch(ai)
	ai.player = self
	if ai.duration > 0:
		$EffectTimer.wait_time = ai.duration
		$EffectTimer.connect("timeout", ai, "_on_Timer_timeout")


# Returns a vector of the force that the player should exert on a body
#	body - Body to determine gravity force 
#	return - Gravity force between player and body
func pull(body:Node2D) -> Vector2:
	var force:Vector2 = global_position - body.global_position
	var distance:float = force.length()
	distance = clamp(distance, 1, 70)
	force = force.normalized()
	var strength:float = 50000.0 / (distance * distance)
	force *= strength
	return force


# Event handler for when a player enters a ladder.
func _on_Ladder_Entered():
	is_on_ladder = true
	animated_sprite.play("climb")
	equipped_gun.visible = false
	# print(Player.is_on_ladder)


# Handler for when player exits a ladder.
func _on_Ladder_Exited():
	running = false
	is_on_ladder = false
	equipped_gun.visible = true


# Add health to player
func _on_RegenTimer_Timeout():
	health += 1
	if health > max_health:
		health = max_health
	hud.health_update(health, 0)


# Allow item to be used again, and stop the looping timer.
func _on_CDTimer_timeout():
	active_item.is_ready = true
	hud.get_node("ActiveItem").invert_enable = true
	hud.get_node("CDTimer").stop()
	hud.get_node("CDText").text = ""
	material = null