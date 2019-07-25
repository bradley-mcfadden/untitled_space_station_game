extends Area2D
class_name Coin

var velocity:Vector2
var active:bool


# Init
func _ready():
	velocity = Vector2(rand_range(-2, 2), rand_range(-2, 2))
	active = false


# Update location of object
#	delta - Time since last physics step
func _physics_process(delta):
	position += velocity
	rotation = atan2(velocity.y, velocity.x)


# Apply some acceleration force to this coin
#	force - Vector to add to acceleration
func apply_force(force:Vector2):
	if active == true:
		velocity = force


# Make the coin able to be picked up
func _on_ActiveTimer_timeout():
	active = true


# Handle coins colliding with a body
#	body - Body that collided with area
func _on_Coin_body_entered(body:PhysicsBody2D):
	if body is Player && active == true:
		body.coins += 1
		body.HUD.coin_update(body.coins)
		queue_free()
