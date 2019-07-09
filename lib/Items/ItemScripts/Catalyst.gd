extends Item

# Init
func _init():
	image = texture
	title = "Catalyst"	
	
# Regen 1 health every 2 seconds
#	p - Player to apply effect to
func effect(p):
	var regenTimer:Timer = Timer.new()
	regenTimer.autostart = true
	regenTimer.wait_time = 1
	regenTimer.connect("timeout",p,"_on_RegenTimer_Timeout")
	p.add_child(regenTimer)
	