extends Node2D

@export var tooth_targets : Array[AnimatedSprite2D]
@export var shift_timer : Timer
# How many teeth roll in.
@export var target_pool_size : int = 25
var target_pool : Array[int] = []
# How many frames the targets have
var tooth_types : int = 3

func _ready():
	
	shift_timer.connect("timeout", shift_teeth)
	
func create_target_pool(size : int):
	for num in size:
		target_pool.append(randi_range(0,tooth_types))
	

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_up"):
		tooth_targets[0].set_new_frame(2)
	elif event.is_action_pressed("ui_down"):
		tooth_targets[0].set_new_frame(1)


func shift_teeth():
	pass
