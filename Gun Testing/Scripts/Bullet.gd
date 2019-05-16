extends RigidBody2D

var speed
var count = 0
func _ready():
	#print("am alive")
	linear_velocity.x = speed * cos(rotation)
	linear_velocity.y = speed * sin(rotation)
	#visible = false
	
func _process(delta):
	if (count >= 600):
		queue_free()
	elif count >= 1:
		visible = true
	count += 1
	

func _on_VisibilityNotifier2D_screen_exited():
	#print("Exit caught")
	queue_free()
