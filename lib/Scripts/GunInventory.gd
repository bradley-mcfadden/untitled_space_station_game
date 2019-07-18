# This is a special set for guns that acts like a wheel with a pointer of the current 
# position. You can rotate through it, but only in one way
extends Object
class_name GunInventory
var guns:Array
var current:int

# Called on initialization
func _init():
	guns = []
	current = -1

# Add a gun to the inventory if not already in it
#	g - Gun to be added
func add(g:Gun):
	var duplicate = contains(g)
	if duplicate >= 0:
		guns[duplicate].currentDurability += g.currentDurability
	else:
		guns.append(g)
		if guns.size() == 1:
			current = 0

# Check if set contains a gun
#	return - Index of search item, or -1 if not found
func contains(g:Gun) -> int:
	for i in range(guns.size()):
		if g.get_script() == guns[i].get_script():
			return i
	return -1

# Rotate through inventory and return the next gun
#	return - Next gun in inventory or null if set is empty
func swap_current() -> Gun:
	if guns.size() > 1:
		if current+1 < guns.size():
			current += 1
		else:
			current = 0
		# guns[current].canFire = true
		return guns[current]
	return null

# Returns the gun at current position
#	return - Gun at current position
func get_current() -> Gun:
	if current >= 0:
		return guns[current]
	return null

# Removes current gun from inventory
func remove_current():
	var oldCurrent = current
	swap_current()
	guns.remove(oldCurrent)
	if oldCurrent == current:
		current = -1