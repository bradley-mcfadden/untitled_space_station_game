extends Node2D
onready var count:float
onready var step:float
onready var item:Sprite
onready var isCarryable:bool
signal pickup(dropped,contents)

func _ready():
	count = 50.0 
	step = 2.0
	isCarryable = false
	$PickupDelay.start()

func _process(delta):
	if count == 0:
		step = -2.0
	elif count == 50:
		step = 2.0
	count -= step
	position.y -= step/10

func set_item(i):
	$Sprite.texture = i.texture
	item = i

func _on_PickupDelay_timeout():
	isCarryable = true

func _on_Area2D_body_entered(body):
	if isCarryable and body is Player:
		emit_signal("pickup",self,item)
