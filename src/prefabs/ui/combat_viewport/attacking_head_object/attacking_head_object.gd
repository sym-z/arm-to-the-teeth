extends VBoxContainer
@export var str_label : RichTextLabel
@export var health_label : RichTextLabel

var head_reference : Head

# Gives the reference back to the combat viewport of the head to use for combat
signal attacking_head_selected(h : Head)
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func input_head(h : Head):
	str_label.text = "STRENGTH: " + str(h.strength)
	health_label.text = "HEALTH: " + str(h.health)
	head_reference = h

func _on_select_button_pressed():
	attacking_head_selected.emit()
