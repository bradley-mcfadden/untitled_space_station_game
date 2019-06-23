extends Node2D
onready var numEnemies:int
func _ready():
	numEnemies = get_child_count()