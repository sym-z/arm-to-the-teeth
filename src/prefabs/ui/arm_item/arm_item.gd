extends PanelContainer

@export var title : Label
@export var strength : Label
@export var condition : Label
@export var equipped : Label

var arm_object : Arm
# When eat is pressed, the signal is emitted back to the UI of the arm object eaten.
signal eat_pressed(arm_object)
# When an arm has been fully eaten, also fire this signal, and destroy yourself
signal arm_fully_eaten(arm_object)
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

# Given an arm and its number in the inventory, convert the pieces of this UI to represent it.
func set_text_to_arm(a : Arm, number : int):
	arm_object = a
	title.text = "ARM " + str(number)
	strength.text = "STRENGTH: " + str(a.strength)
	condition.text = "CONDITION: " + str(a.condition)
	if a.equipped == true:
		equipped.text = "EQUIPPED"
	else:
		equipped.text = "NOT EQUIPPED"


func _on_eat_button_pressed():
	eat_pressed.emit(arm_object)
	condition.text = "CONDITION: " + str(arm_object.condition)
	if arm_object.condition <= 0:
		arm_fully_eaten.emit(arm_object)
		call_deferred("queue_free")
