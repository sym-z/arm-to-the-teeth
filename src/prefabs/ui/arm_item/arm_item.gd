extends PanelContainer

@export var title : Label
@export var strength : Label
@export var condition : Label
@export var equipped : Label
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

# Given an arm and its number in the inventory, convert the pieces of this UI to represent it.
func set_text_to_arm(a : Arm, number : int):
	title.text = "ARM " + str(number)
	strength.text = "STRENGTH: " + str(a.strength)
	condition.text = "CONDITION: " + str(a.condition)
	if a.equipped == true:
		equipped.text = "EQUIPPED"
	else:
		equipped.text = "NOT EQUIPPED"
