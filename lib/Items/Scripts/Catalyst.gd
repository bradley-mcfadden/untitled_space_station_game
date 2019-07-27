extends Item


# Init
func _init():
	image = texture
	title = "Catalyst"	

	
# Regen 1 health every 2 seconds
#	player - Player to apply effect to
func effect(player:KinematicBody2D):
	var regen_timer:Timer = Timer.new()
	regen_timer.autostart = true
	regen_timer.wait_time = 1
	regen_timer.connect("timeout", player, "_on_RegenTimer_Timeout")
	player.add_child(regen_timer)
	