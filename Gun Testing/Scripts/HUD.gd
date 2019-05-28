extends CanvasLayer

# Init
func _ready():
	$HealthBar.value = get_parent().MAX_HEALTH
	$CoinCountLabel.text = str(get_parent().coins)
	$RestartButton.connect("pressed", get_parent().get_parent(),"new_game")

# Update the progress of the health bar
#	health - New health value
func healthUpdate(health:int):
	$HealthBar.value = health

# Replaces the image in the gun image
#	Gun to set image to
func _on_weaponSwap(weapon:Gun):
	if weapon is AnimatedSprite:
		#print("yes")
		var frames = weapon.get_sprite_frames()
		var def = frames.get_frame("default",0)
		$WeaponRect.texture = def
	$AmmoLabel.text = str(weapon.actualBullets) +"\n"+str(weapon.clipSize)
	$WeaponLabel.text = weapon.gunName

# Updates text of the ammo label to current clip size
#	Gun to take properties from	
func _on_updateGun(weapon:Gun):
	$AmmoLabel.text = str(weapon.actualBullets) +"\n"+str(weapon.clipSize)
	
