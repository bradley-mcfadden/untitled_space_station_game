extends Area2D
class_name Chest
enum {WHITE,GREEN,BLUE,PURPLE,ORANGE}
signal chest_entered(pos,lootPool)
onready var type:int

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	var rng = rand_range(0,1)
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
	# print(rng," ",type)
	$AnimatedSprite.animation = str(type)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Chest_body_entered(body):
	pass # Replace with function body.
