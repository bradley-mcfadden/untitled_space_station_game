extends RigidBody2D

var speed
var count = 0
var velocity 
#var Player = load("res://Scenes/Player.gd")
func _ready():
	linear_velocity.x = speed * cos(rotation)
	linear_velocity.y = speed * sin(rotation)
	#visible = false
	
func _process(delta):
	
	if (count >= 600):
		queue_free()
	elif count >= 1:
		visible = true
	count += 1
	
func _physics_process(delta):
	var step = linear_velocity * delta
	var space_state = get_world_2d().direct_space_state
	var result = space_state.intersect_ray(global_position,global_position+step)
	if result:
		print(result.collider)
		if result.collider is Enemy:
			print("Got em fellas")
		if result.collider is Gun:
			print("Not good")
		if result.collider is Player:
			print("Fucking kill me")
		queue_free()
	

func _on_VisibilityNotifier2D_screen_exited():
	pass
	#print("Exit caught")
	#queue_free()
