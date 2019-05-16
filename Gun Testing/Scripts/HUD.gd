extends CanvasLayer

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_weaponSwap(weapon:Gun):
	if weapon is AnimatedSprite:
		print("yes")
		var frames = weapon.get_sprite_frames()
		var def = frames.get_frame("default",0)
		$WeaponRect.texture = def
	$AmmoLabel.text = str(weapon.actualBullets) +"\n"+str(weapon.clipSize)
	$WeaponLabel.text = weapon.gunName
func _on_updateUI(weapon:Gun):
	$AmmoLabel.text = str(weapon.actualBullets) +"\n"+str(weapon.clipSize)
	
