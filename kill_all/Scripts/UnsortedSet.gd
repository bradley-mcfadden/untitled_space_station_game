# An UnsortedSet is a data structure that contains no duplicates
# It ensures that any object added is not already in the set.
# Its elements are in no special order
extends Node

class_name UnsortedSet
var data = []

# Does the set contain this object already?
#	return - Contain or not
func contains(t) -> bool:
	for i in range(data.size()):
		if data[i] is Object and data[i].equals(t):
			return true
		elif data[i] == t:
			return true
	return false

# Adds an object to the set
#	return - Was the object added successfully?
func add(t) -> bool:
	if contains(t):
		return false
	data.append(t)
	return true

# Calls to_string for every object in the set	
# return - State of the set
func to_string() -> String:
	var s = "["
	for i in range(data.size()):
		s += data[i]
	s += "]"
	return s