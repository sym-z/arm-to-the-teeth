extends AnimatedSprite2D
@export var eat_icon : Sprite2D
@export var mouse_field : ColorRect
@export var root_ui : CanvasLayer

#NOTE: Set this when an arm is attached
var arm_ref : Arm = null

func _ready():
	mouse_field.connect("mouse_entered", _field_entered)
	mouse_field.connect("mouse_exited", _field_exited)
	mouse_field.connect("gui_input", _field_clicked)
	eat_icon.visible = false

func _field_entered():
	eat_icon.visible = true

func _field_exited():
	eat_icon.visible = false

func _field_clicked(event):
	if event is InputEventMouseButton and event.button_index == 1 and event.pressed == true:
		if arm_ref == null:
			push_error("attempting to eat an null reference arm")
			return
		print(event)
		root_ui.arm_eaten(arm_ref)
		if arm_ref.condition <= 0:
			root_ui.arm_fully_eaten(arm_ref)
			arm_ref = null
