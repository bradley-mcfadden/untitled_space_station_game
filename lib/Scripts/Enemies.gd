extends Node2D
onready var num_enemies:int


func _ready():
	num_enemies = get_child_count()


# Update the material of all enemies in the room
#	material - New material to set
func update_material(material:ShaderMaterial):
	for child in get_children():
		child.update_material(material)