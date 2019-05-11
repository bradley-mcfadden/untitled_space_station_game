extends Node2D
var speed = 200
var velocity
func _process(delta):
	velocity = Vector2()
	if (Input.is_action_pressed("ui_left")):
		velocity.x = -speed * delta
	if (Input.is_action_pressed("ui_right")):
		velocity.x = speed * delta
	if (Input.is_action_pressed("ui_up")):
		velocity.y = -speed * delta
	if (Input.is_action_pressed("ui_down")):
		velocity.y = speed * delta
	position += velocity