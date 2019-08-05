extends ActiveItem


# Set the title of the Active Item
func _init():
	title = "Devil's Deal"
	cooldown = 2
	duration = 40
	is_ready = true


# Define the function to be called when active item is pressed
func active_effect():
	var main:Node2D = player.get_parent()
	var player_room:int = main.world.find_player_index(player.position)
	if player_room < 0:
		return
	if main.world.enemies[player_room] != null:
		var enemies:Array = main.world.enemies[player_room].get_children()
		if enemies.size() == 0:
			return
		player.material = load("res://Shaders/OscillatingRed.shader")
		player.take_damage(1 + int(player.health * 0.30), Vector2(0, 0))
		enemies[randi() % enemies.size()].take_damage(1000000, Vector2(0, 0))


# Timer for invulnerability to end
func _on_Timer_timeout():
	player.get_node("CDTimer").start()
	player.hud.get_node("CDTimer").start()
	player.material = null