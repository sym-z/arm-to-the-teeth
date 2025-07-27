extends AnimatedSprite2D

## How high and low the roll can be 
@export var lower_limit : int = 1
@export var upper_limit : int = 20
## Minimum roll to automatically pass a check
@export var difficulty_class : int = 0
## Did the player roll higher than the DC
var roll_passed : bool = false

## Allows for stopping the die by clicking
var is_rolling : bool = false
## Prevents multiple rolls
var roll_finished : bool = false

signal roll_results_ready(passed: bool, number_rolled: int)
# Called when the node enters the scene tree for the first time.
func _ready():
	frame = lower_limit -1
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if frame == upper_limit:
		frame = lower_limit -1

func roll_die():
	print("ROLLING")
	play()
	is_rolling = true

func set_die(lower : int = lower_limit, upper : int = upper_limit, dc : int = difficulty_class):
	frame = lower_limit -1
	upper_limit = upper
	lower_limit = lower
	difficulty_class = dc
	print("DIE SET")

func _on_mouse_handler_gui_input(event):
	if event is InputEventMouseButton and event.button_index == 1 and event.pressed == true:
		if is_rolling == false and roll_finished == false:
			roll_die()
			print("DIE ROLLING STARTED")
		else:
			print("DIE ROLLING STOPPED")
			pause()
			roll_finished = true
			var result : int = frame + 1
			if result >= difficulty_class:
				roll_passed = true
			else:
				roll_passed = false
			roll_results_ready.emit(roll_passed, result)
			
		




func _on_animation_finished():
	print("ANIM FINISHED")
	frame =lower_limit -1
	play()
