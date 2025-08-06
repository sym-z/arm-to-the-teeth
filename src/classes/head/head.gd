class_name Head extends Resource

var max_health : int = 5
var health : int = max_health
var strength : int = 1

const TOOTH_MAX : int = 32
var tooth_count : int = 6

## Attempts to add teeth, returns the number of teeth left over
func add_teeth(num_teeth : int) -> int:
	for i in range(num_teeth):
		if tooth_count < TOOTH_MAX:
			tooth_count += 1
		else:
			# TODO: Log message about leftover teeth
			Log.add_log_message("IT TRIED TO PUSH " + str(num_teeth) + " INTO ITS HEAD, BUT IT COULD ONLY FIT " + str(i))
			return num_teeth - i
	# All teeth added
	Log.add_log_message("IT PUSHED " + str(num_teeth) + " TEETH INTO ITS HEAD")
	return 0
			
func remove_teeth(num_teeth : int):
	for i in range(num_teeth):
		if tooth_count > 0:
			tooth_count -= 1
		else:
			# TODO: Log message about leftover teeth
			return
			
