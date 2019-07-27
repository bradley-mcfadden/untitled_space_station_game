extends Node2D


var speed:int = 200
var velocity:Vector2
# Controls: WASD or arrows to scroll camera
#			R to zoom in
#			T to zoom out


# Called each frame, handles input
#	delta - Time since previous frame
func _process(delta:float):
	velocity = Vector2()
	if (Input.is_action_pressed("ui_left")):
		velocity.x = -speed * delta
	if (Input.is_action_pressed("ui_right")):
		velocity.x = speed * delta
	if (Input.is_action_pressed("ui_up")):
		velocity.y = -speed * delta
	if (Input.is_action_pressed("ui_down")):
		velocity.y = speed * delta
	if (Input.is_action_pressed("scroll_down")):
		$Camera2D.zoom *= 0.99
		speed *= 0.99
	if (Input.is_action_pressed("scroll_up")):
		$Camera2D.zoom *= 1.01	
		speed *= 1.01
	position += velocity