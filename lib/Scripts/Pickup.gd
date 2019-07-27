extends Node2D
class_name Pickup
export var random:bool = false
export var cost:int = 0
onready var count:float
onready var step:float
onready var item:Sprite
onready var is_carryable:bool
onready var purchased:bool
signal pickup_entered(dropped,contents)
signal pickup_exited()


# Init
func _ready():
	if random == true:
		var item_contained:Sprite
		if (randi() % 2) - 1 < 0:
			var item_index:int = randi() % GlobalVariables.GUNREF.size()
			item_contained = GlobalVariables.GUNREF[item_index].instance()
		else:
			var item_index:int = randi() % GlobalVariables.LOOT_POOL_ACTIVE.size()
			item_contained = GlobalVariables.LOOT_POOL_ACTIVE[item_index].instance()
		var main_reference:Node = get_parent().get_parent().get_parent()
		set_item(item_contained)
		connect("pickup_entered", main_reference, "_on_Pickup_Entered")
		connect("pickup_exited", main_reference, "_on_Pickup_Exited")
		$Label.visible = true
		$Label.text = str(cost)
	purchased = false
	count = 50.0 
	step = 2.0
	is_carryable = false
	$PickupDelay.start()


# Makes sprite bob up and down
#	delta - Time since last frame
#warning-ignore:unused_argument
func _process(delta:float):
	if count == 0:
		step = -2.0
	elif count == 50:
		step = 2.0
	count -= step
	position.y -= step / 10


# Setter for item
#	i - Either an item or an active Item
func set_item(i:Sprite):
	$Sprite.texture = i.texture
	item = i


# Allows for item to be picked up after some initial delay
func _on_PickupDelay_timeout():
	is_carryable = true


# Sends out a signal when item is entered
func _on_Area2D_body_entered(body:PhysicsBody2D):
	if is_carryable == true && body.get_script() == load("res://Scripts/Player.gd"):
		emit_signal("pickup_entered", self, item)


# Send out a signal when item exited
func _on_Area2D_body_exited(body:PhysicsBody2D):
	if is_carryable == true && body.get_script() == load("res://Scripts/Player.gd") && cost > 0 && purchased == false:
		emit_signal("pickup_exited")