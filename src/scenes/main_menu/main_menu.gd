extends CanvasLayer

@export var play_button : Button
@export var tutorial_button : Button
@export var quit_button : Button

@export var score_label : Label

@export var chomp_transition : AnimatedSprite2D

func _ready():
	chomp_transition.open()
	play_button.connect("pressed", start_game)
	quit_button.connect("pressed", quit_game)
	tutorial_button.connect("pressed", tutorial)
	score_label.text = "HIGHEST FLOOR REACHED: " + str(Globals.highest_floor)

func start_game():
	Globals.curr_floor = 0
	Log.log_messages.clear()
	chomp_transition.close(SceneTransition.testing_level)

func tutorial():
	chomp_transition.close(SceneTransition.tutorial)

func quit_game():
	chomp_transition.close(get_tree().quit)
