extends CanvasLayer

@export var play_button : Button
@export var tutorial_button : Button
@export var quit_button : Button

@export var score_label : Label

func _ready():
	play_button.connect("pressed", start_game)
	quit_button.connect("pressed", quit_game)
	tutorial_button.connect("pressed", tutorial)
	score_label.text = "HIGHEST FLOOR REACHED: " + str(Globals.highest_floor)

func start_game():
	Globals.curr_floor = 0
	Log.log_messages.clear()
	SceneTransition.testing_level()

func tutorial():
	SceneTransition.tutorial()

func quit_game():
	get_tree().quit()
