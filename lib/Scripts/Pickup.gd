extends Node2D
class_name Pickup
export var random:bool = false
export var cost:int = 0
onready var count:float
onready var step:float
onready var item:Sprite
onready var isCarryable:bool
onready var purchased:bool
signal pickup(dropped,contents)
signal exit()

# Init
func _ready():
	if random == true:
		var mainRef = get_parent().get_parent().get_parent()
		set_item(mainRef.lootPoolWHITE[0].instance())
		connect("pickup",mainRef,"_on_Pickup_Entered")
		connect("exit",mainRef,"_on_Pickup_Exited")
		$Label.visible = true
		$Label.text = str(cost)
	purchased = false
	count = 50.0 
	step = 2.0
	isCarryable = false
	$PickupDelay.start()

# Makes sprite bob up and down
#	delta - Time since last frame
func _process(delta):
	if count == 0:
		step = -2.0
	elif count == 50:
		step = 2.0
	count -= step
	position.y -= step/10

# Setter for item
#	i - Either an item or an active Item
func set_item(i):
	$Sprite.texture = i.texture
	item = i

# Allows for item to be picked up after some initial delay
func _on_PickupDelay_timeout():
	isCarryable = true

# Sends out a signal when item is entered
func _on_Area2D_body_entered(body):
	if isCarryable and body is Player:
		emit_signal("pickup",self,item)

# Send out a signal when item exited
func _on_Area2D_body_exited(body):
	if isCarryable and body is Player and cost > 0 and purchased == false:
		emit_signal("exit")
