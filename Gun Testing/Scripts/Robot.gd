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
	#collisionShape.
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	#print(collisionShape.position.y)
