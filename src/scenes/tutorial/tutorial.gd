extends CanvasLayer

@export var play_button : Button
@export var back_button : Button
# Called when the node enters the scene tree for the first time.
func _ready():
	play_button.connect("pressed", play_game)
	back_button.connect("pressed", main_menu)

func main_menu():
	SceneTransition.main_menu()

func play_game():
	Globals.curr_floor = 0
	Log.log_messages.clear()
	SceneTransition.testing_level()
