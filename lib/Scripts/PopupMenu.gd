extends PopupMenu


func _ready():
	add_item("Developer Options")
	add_separator()
	
	for active_item in GlobalVariables.LOOT_POOL_ACTIVE:
		$AddItems/ActiveItems.add_item(active_item.instance().title)
	$AddItems.add_submenu_item("Active Items", "ActiveItems")
	
	for gun in GlobalVariables.GUNREF:
		$AddItems/Guns.add_item(gun.instance().title)
	
	for item in GlobalVariables.ALL_ITEMS:
		$AddItems/Items.add_item(item.instance().title)
	
	$AddItems.add_submenu_item("Guns", "Guns")
	$AddItems.add_submenu_item("Items", "Items")
	add_submenu_item("Add Items", "AddItems")
	
	add_item("Clear room")
