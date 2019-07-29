extends Enemy


# Called when the node enters the scene tree for the first time.
func _ready():
	var enemyFrames:SpriteFrames = preload("res://Enemies/EnemySprites/Robot/Robot.tres")
	sprite_anim = AnimatedSprite.new()
	sprite_anim.set_sprite_frames(enemyFrames)
	add_child(sprite_anim)
	sprite_anim.play()
	collision_shape = CollisionShape2D.new()
	
	var hitbox:RectangleShape2D = RectangleShape2D.new()
	hitbox.extents.x = 10
	hitbox.extents.y = 22
	collision_shape.shape = hitbox
	add_child(collision_shape)
	
	front_cast = RayCast2D.new()
	front_cast.cast_to.x = -15
	front_cast.cast_to.y = 0
	front_cast.enabled = true
	add_child(front_cast)
	
	front_floor_cast = RayCast2D.new()
	front_floor_cast.position = Vector2(-5, 0)
	front_floor_cast.cast_to = Vector2(-5, 30)
	front_floor_cast.enabled = true
	add_child(front_floor_cast)
	material = load("res://Shaders/Negative.tres")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#	delta - Time elapsed since previous frame
func _physics_process(delta:float):
	var coll:Object = front_cast.get_collider()
	if (front_cast.is_colliding() && coll is TileMap) || !front_floor_cast.is_colliding():
		direction *= -1
		scale.x *= -1
	elif coll is Player:
		coll.take_damage(damage, Vector2(direction * movespeed*damage, 0))
	if !is_on_floor():
		move_and_slide(Vector2(0, GRAVITY),Vector2(0, -1))
	else:
		move_and_slide(Vector2(direction * movespeed, 0), Vector2(0, -1))
