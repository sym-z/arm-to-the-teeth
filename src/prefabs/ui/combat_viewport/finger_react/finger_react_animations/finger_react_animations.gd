extends Node2D

@export var fing_1 : AnimatedSprite2D
@export var fing_2 : AnimatedSprite2D
@export var fing_3 : AnimatedSprite2D

var curr_anim : AnimatedSprite2D = fing_3

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func emit_cut_signal():
	pass
func set_finger_number(num : int):
	if num > 3 or num < 1:
		push_error("Invalid finger number setting in set_finger_number() in finger_react_animations.gd")
	match num:
		1:
			fing_1.visible = true
			fing_2.visible = false
			fing_3.visible = false
			curr_anim = fing_1
		2:
			fing_1.visible = false
			fing_2.visible = true
			fing_3.visible = false
			curr_anim = fing_2
		3:
			fing_1.visible = false
			fing_2.visible = false
			fing_3.visible = true
			curr_anim = fing_3
	curr_anim.animation = "default"
