extends Node

var data = []

func contains(t) -> bool:
	for i in range(data.size()):
		if data[i].equals(t):
			return true
	return false

func add(t):
	if contains(t):
		return
	data.append(t)
	
func to_string() -> String:
	var s = "["
	for i in range(data.size()):
		s += data[i]
	s += "]"
	return s

