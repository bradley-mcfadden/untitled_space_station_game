extends Enemy
# Called when the node enters the scene tree for the first time.
func _ready():
	var enemyFrames = preload("res://EnemySprites/Robot/Robot.tres")
	spriteAnim = AnimatedSprite.new()
	spriteAnim.set_sprite_frames(enemyFrames)
	add_child(spriteAnim)
	spriteAnim.play()
	collisionShape = CollisionShape2D.new()
	
	var hitbox = RectangleShape2D.new()
	hitbox.extents.x = 10
	hitbox.extents.y = 22
	collisionShape.shape = hitbox
	add_child(collisionShape)
	
	frontCast = RayCast2D.new()
	frontCast.cast_to.x = -15
	frontCast.cast_to.y = 0
	frontCast.enabled = true
	add_child(frontCast)
	
	frontFloorCast = RayCast2D.new()
	frontFloorCast.position = Vector2(-5,0)
	frontFloorCast.cast_to = Vector2(-5,30)
	frontFloorCast.enabled = true
	add_child(frontFloorCast)
	
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	var coll = frontCast.get_collider()
	if (frontCast.is_colliding() && coll is TileMap) || !frontFloorCast.is_colliding():
		direction *= -1
		scale.x *= -1
	elif coll is Player:
		coll.take_damage(damage,Vector2(direction*movespeed*damage,0))
	if !is_on_floor():
		move_and_slide(Vector2(0,GRAVITY),Vector2(0,-1))
	else:
		move_and_slide(Vector2(direction*movespeed,0),Vector2(0,-1))
	#print(collisionShape.position.y)
