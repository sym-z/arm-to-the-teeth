extends PanelContainer
@export var str_label : RichTextLabel
@export var con_label : RichTextLabel

var arm_reference : Arm

# Gives the reference back to the combat viewport of the arm to use for combat
signal attacking_arm_selected()
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func input_arm(a : Arm):
	str_label.text = "STRENGTH: " + str(a.strength)
	con_label.text = "CONDITION: " + str(a.condition)
	arm_reference = a


func _on_select_button_pressed():
	attacking_arm_selected.emit(arm_reference,false)
