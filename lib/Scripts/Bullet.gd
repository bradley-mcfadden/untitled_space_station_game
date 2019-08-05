extends RigidBody2D
class_name Bullet


var speed:float
var count := 0
var velocity:Vector2
var damage:int
var dead:bool
var dead_buffer:int


func _ready():
	linear_velocity.x = speed * cos(rotation)
	linear_velocity.y = speed * sin(rotation)
	dead = false
	dead_buffer = 3


# Process and handle collisions	
#	delta - Time since last frame
func _physics_process(delta:float):
	if dead == true:
		dead_buffer -= 1
	if dead_buffer == 0 || linear_velocity.length() < 50:
		queue_free()
	var step:Vector2 = linear_velocity * delta
	var space_state:Physics2DDirectSpaceState = get_world_2d().direct_space_state
	var result:Dictionary = space_state.intersect_ray(global_position, global_position + step)
	if !result.empty():
		# print(result)
		if result["collider"] is Enemy && dead == false:
			result["collider"].take_damage(PlayerVariables.damage_multiplier * damage,
					Vector2(linear_velocity.x * delta * PlayerVariables.knockback_multiplier, linear_velocity.y))
			dead = true
		elif result["collider"] is TileMap:
			dead = true


# Handles exceptional circumstances when a bullet could fall off screen
func _on_VisibilityNotifier2D_screen_exited():
	queue_free()