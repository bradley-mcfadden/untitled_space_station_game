extends CanvasLayer


# Init
func _ready():
	$HealthBar.value = get_parent().max_health
	$CoinCountLabel.text = str(get_parent().coins)
	$RestartButton.connect("pressed", get_parent().get_parent(), "new_game")
	$HealthLabel.text = str(get_parent().health) + "/" + str(get_parent().max_health)


# Update number of coins
#	coins - Number of coins to change text field to
func coin_update(coins:int):
	$CoinCountLabel.text = str(coins)


# Update the progress of the health bar
#	health - New health value
func health_update(health:int, max_health=0):
	$HealthBar.max_value += max_health
	if max_health > health:
		$HealthBar.value = max_health
	else:
		$HealthBar.value = health
	$HealthLabel.text = str(get_parent().health) + "/" + str(get_parent().max_health)


# Replaces the image in the gun image
#	Gun to set image to
func _on_weapon_swap(weapon:Gun):
	$WeaponRect.texture = weapon.texture
	$AmmoLabel.text = str(weapon.actual_bullets) + "\n" + str(weapon.current_durability)
	$WeaponLabel.text = weapon.gun_name


# Updates text of the ammo label to current clip size
#	Gun to take properties from	
func _on_update_gun(weapon:Gun):
	$AmmoLabel.text = str(weapon.actual_bullets) + "\n" + str(weapon.current_durability)


# Update the HUD for a new ActiveItem
#	item - Item to update with
func active_item_swtich(item:ActiveItem):
	$ActiveLabel.text = item.title
	$ActiveItemLabel.texture = item.texture


# Takes an item, and adds it to the GUI of the player inventory
#	i - Item reference
func add_item(i:Item):
	var texture:TextureRect = TextureRect.new()
	texture.rect_position.x = 16 + ($Inventory.WIDTH / 13) * ($Inventory.items.size() % 12)
	texture.rect_position.y += 16 + ($Inventory.HEIGHT / 2) * ($Inventory.items.size() / 12)
	$Inventory.items.append(texture)
	texture.texture = i.texture
	$Inventory.add_child(texture)
	
	
# Puts text into the MessageLabel. Disappears after 5 seconds.
#	text - Message to show
func fading_message(text:String):
	$MessageLabel.visible = true
	$MessageLabel.text = text
	$FadingMessageTimer.start()


# Setter for text in the message label
#	text - Text to set the label to
func set_message_text(text:String):
	$MessageLabel.text = text
	$MessageLabel.visible = true
	
	
# Clears label text and makes label invisible
func _on_Timer_timeout():
	$MessageLabel.visible = false
	$MessageLabel.text = ''


# Updates the time count of the active item label
func _on_CDTimer_timeout():
	$CDText.text = int(get_parent().get_node("CDTimer").time_left)
