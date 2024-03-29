extends Area2D
class_name Chest


enum {WHITE, GREEN, BLUE, PURPLE, ORANGE}
signal chest_entered(chest, loot_pool)
onready var type:int


# Called when the node enters the scene tree for the first time.
func _ready():
	var x:Node = get_parent().get_parent().get_parent()
	if x.get_script() == load("res://Scripts/Main.gd"):
		self.connect("chest_entered", x, "_on_Chest_Entered")
	randomize()
	var rng:float = rand_range(0, 1)
	if rng < 0.35:
		type = WHITE
	elif rng < 0.65:
		type = GREEN
	elif rng < 0.85:
		type = BLUE
	elif rng < 0.95:
		type = PURPLE
	else:
		type = ORANGE
	$AnimatedSprite.animation = str(type)


# Event handler for when chest is passed through
#	body - What passed through it?
func _on_Chest_body_entered(body:PhysicsBody2D):
	if body is Player:
		emit_signal("chest_entered", self, type)
		$AnimatedSprite.play(str(type) + "opened")