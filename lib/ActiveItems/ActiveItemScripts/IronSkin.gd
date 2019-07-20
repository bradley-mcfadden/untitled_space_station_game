extends ActiveItem

# Set the title of the Active Item
func _init():
	title = "Iron Skin"

# Define the function to be called when active item is pressed
func active_effect():
	p.ironSkin = true
	p.movespeed *= 0.9
	p.speedCap *= 0.8
	$Timer.start()

# Timer for invulnerability to end
func _on_Timer_timeout():
	p.ironSkin = false
	p.movespeed *= 1.0 / 0.9
	p.speedCap *= 1.0 / 0.9
