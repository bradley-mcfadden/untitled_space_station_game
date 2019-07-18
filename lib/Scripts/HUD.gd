extends CanvasLayer

# Init
func _ready():
	$HealthBar.value = get_parent().maxHealth
	$CoinCountLabel.text = str(get_parent().coins)
	$RestartButton.connect("pressed", get_parent().get_parent(),"new_game")
	$HealthLabel.text = str(get_parent().health)+"/"+str(get_parent().maxHealth)

# Update number of coins
#	coins - Number of coins to change text field to
func coin_update(coins:int):
	$CoinCountLabel.text = str(coins)

# Update the progress of the health bar
#	health - New health value
func health_update(health:int,maxHealth=0):
	$HealthBar.max_value += maxHealth
	if maxHealth > health:
		$HealthBar.value = maxHealth
	else:
		$HealthBar.value = health
	$HealthLabel.text = str(get_parent().health)+"/"+str(get_parent().maxHealth)

# Replaces the image in the gun image
#	Gun to set image to
func _on_weapon_swap(weapon:Gun):
	$WeaponRect.texture = weapon.texture
	$AmmoLabel.text = str(weapon.actualBullets) +"\n"+str(weapon.currentDurability)
	$WeaponLabel.text = weapon.gunName

# Updates text of the ammo label to current clip size
#	Gun to take properties from	
func _on_update_gun(weapon:Gun):
	$AmmoLabel.text = str(weapon.actualBullets) +"\n"+str(weapon.currentDurability)

# Takes an item, and adds it to the GUI of the player inventory
#	i - Item reference
func add_item(i:Item):
	var texture = TextureRect.new()
	texture.rect_position.x = 16 + ($Inventory.WIDTH/13)*($Inventory.items.size()%12)
	texture.rect_position.y += 16 + ($Inventory.HEIGHT/2)*($Inventory.items.size()/12)
	$Inventory.items.append(texture)
	texture.texture = i.texture
	# texture.rect_position = $Inventory.position
	$Inventory.add_child(texture)
	# texture.rect_position.y += $Inventory.HEIGHT/4
	# print($LifeLabel.rect_global_position)
	# print($Inventory.global_position)
	# print(texture.rect_global_position)
	
# Puts text into the MessageLabel. Disappears after 5 seconds.
#	text - Message to show
func fading_message(text:String):
	$MessageLabel.visible = true
	$MessageLabel.text = text
	$Timer.start()

# Setter for text in the message label
#	text - Text to set the label to
func set_message_text(text:String):
	$MessageLabel.text = text
	$MessageLabel.visible = true
	
# Clears label text and makes label invisible
func _on_Timer_timeout():
	$MessageLabel.visible = false
	$MessageLabel.text = ''
