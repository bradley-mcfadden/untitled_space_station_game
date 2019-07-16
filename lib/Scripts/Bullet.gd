extends RigidBody2D
class_name Bullet
var speed
var count = 0
var velocity
var damage:int
var dead:bool
var deadBuffer:int
func _ready():
	linear_velocity.x = speed * cos(rotation)
	linear_velocity.y = speed * sin(rotation)
	dead = false
	deadBuffer = 3
	
# Process and handle collisions	
#	delta - Time since last frame
func _physics_process(delta):
	if dead == true:
		deadBuffer -= 1
	if deadBuffer == 0 or linear_velocity.length() < 50:
		queue_free()
		
	var step = linear_velocity * delta
	var space_state = get_world_2d().direct_space_state
	var result = space_state.intersect_ray(global_position,global_position+step)
	if result:
		if result.collider is Enemy && dead == false:
			result.collider.take_damage(damage*PlayerVariables.damageMultiplier,
			damage*linear_velocity*delta*PlayerVariables.knockbackMultiplier)
			dead = true
			#print(damage,result.collider)
			#queue_free()
		elif result.collider is TileMap:
			dead = true
			#queue_free()

# Handles exceptional circumstances when a bullet could fall off screen
func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
