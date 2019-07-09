extends RigidBody2D
class_name Bullet
var speed
var count = 0
var velocity
var damage:int
func _ready():
	linear_velocity.x = speed * cos(rotation)
	linear_velocity.y = speed * sin(rotation)
	
# Processes frame information, handles despawn of 
# bullets. Should replace with a timer.
#	delta - Time since last frame
func _process(delta):
	if (count >= 600):
		queue_free()
	elif count >= 1:
		visible = true
	count += 1
	
# Process and handle collisions	
#	delta - Time since last frame
func _physics_process(delta):
	var step = linear_velocity * delta
	var space_state = get_world_2d().direct_space_state
	var result = space_state.intersect_ray(global_position,global_position+step/40)
	if result:
		if result.collider is Enemy:
			result.collider.take_damage(damage*PlayerVariables.damageMultiplier,
			damage*linear_velocity*delta*PlayerVariables.knockbackMultiplier)
			queue_free()
