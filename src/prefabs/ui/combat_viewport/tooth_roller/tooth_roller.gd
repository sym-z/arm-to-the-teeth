extends Node2D

@export var tooth_targets : Array[AnimatedSprite2D]

## Initial Idea
#func _ready():
	#for tooth in tooth_targets:
		#tooth.set_frame(2)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_up"):
		#for tooth in tooth_targets:
			#tooth.set_frame(2)
		tooth_targets[0].set_new_frame(2)
	elif event.is_action_pressed("ui_down"):
		#for tooth in tooth_targets:
			#tooth.set_frame(1)
		tooth_targets[0].set_new_frame(1)
