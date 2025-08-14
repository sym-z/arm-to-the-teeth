extends CanvasLayer

@export var score_label : Label
@export var retry_button : Button
@export var menu_button : Button
@export var quit_button : Button

func _ready():
	#TODO: Add in high score
	if Globals.curr_floor > Globals.highest_floor:
		Globals.highest_floor = Globals.curr_floor
	score_label.text = "YOU REACHED FLOOR: " + str(Globals.curr_floor) + "\nHIGHEST FLOOR REACHED: " + str(Globals.highest_floor)
	retry_button.connect("pressed", try_again)
	menu_button.connect("pressed", back_to_menu)
	quit_button.connect("pressed", quit_game)

func back_to_menu():
	SceneTransition.main_menu()

func try_again():
	# Retain log if they decide to hit retry.
	Globals.curr_floor = 0
	SceneTransition.testing_level()
	
func quit_game():
	get_tree().quit()
