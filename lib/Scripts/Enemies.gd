extends Node2D
onready var num_enemies:int


func _ready():
	num_enemies = get_child_count()