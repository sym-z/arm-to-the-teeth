extends VBoxContainer

var arm_texture : Texture2D = preload("uid://cwgd7txw32px1")
var head_texture : Texture2D = preload("uid://dksmf7an78qta")

@export var icon : TextureRect
@export var health_label : RichTextLabel

var is_head : bool 
var head_reference : Head
var arm_reference : Arm

signal damage_head(h: Head)
signal damage_arm(a: Arm)
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func input_head(h : Head):
	is_head = true
	health_label.text = "HEALTH: " + str(h.health)
	icon.texture = head_texture
	head_reference = h

func input_arm(a : Arm):
	is_head = false
	health_label.text = "CONDITION: " + str(a.condition)
	icon.texture = arm_texture
	arm_reference = a

func _on_damage_button_pressed():
	if is_head == true:
		damage_head.emit(head_reference)
	else:
		damage_arm.emit(arm_reference)
