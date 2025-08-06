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
			if i == 0:
				return
			elif i == 1:
				Log.add_log_message("IT LOST " + str(i) + " TOOTH.")
			else:
				Log.add_log_message("IT LOST " + str(i) + " TEETH.")
			return
	if num_teeth > 1:
		Log.add_log_message("IT LOST " + str(num_teeth) + " TEETH.")
	else:
		Log.add_log_message("IT LOST " + str(num_teeth) + " TOOTH.")
func damage(amt : int):
	print("YOLO")
	if amt >= health:
		health = 0
	else:
		health -= amt
	# Roll for teeth lost
	var roll : int = randi_range(1,20)
	if roll >= 19:
		remove_teeth(3)
	elif roll >= 15:
		remove_teeth(2)
	elif roll > 10:
		remove_teeth(1)
	Log.add_log_message("IT WAS HIT FOR " + str(amt) + " DAMAGE.")
