extends CanvasLayer

func _ready():
	$HealthBar.value = get_parent().MAX_HEALTH
	$CoinCountLabel.text = str(get_parent().coins)
	$RestartButton.connect("pressed", get_parent().get_parent(),"new_game")

func healthUpdate(health:int):
	$HealthBar.value = health

func _on_weaponSwap(weapon:Gun):
	if weapon is AnimatedSprite:
		#print("yes")
		var frames = weapon.get_sprite_frames()
		var def = frames.get_frame("default",0)
		$WeaponRect.texture = def
	$AmmoLabel.text = str(weapon.actualBullets) +"\n"+str(weapon.clipSize)
	$WeaponLabel.text = weapon.gunName
	
func _on_updateGun(weapon:Gun):
	$AmmoLabel.text = str(weapon.actualBullets) +"\n"+str(weapon.clipSize)
	
