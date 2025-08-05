class_name Head extends Resource

var max_health : int = 5
var health : int = max_health
var strength : int = 1

const TOOTH_MAX : int = 32
var tooth_count : int = 6

func add_teeth(num_teeth : int):
	for i in range(num_teeth):
		if tooth_count < TOOTH_MAX:
			tooth_count += 1
		else:
			# TODO: Log message about leftover teeth
			return
			
func remove_teeth(num_teeth : int):
	for i in range(num_teeth):
		if tooth_count > 0:
			tooth_count -= 1
		else:
			# TODO: Log message about leftover teeth
			return
			
