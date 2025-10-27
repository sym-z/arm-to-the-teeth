extends AnimatedSprite2D

@export var prev_tooth : AnimatedSprite2D
@export var next_tooth : AnimatedSprite2D

@export var is_first : bool
@export var is_last : bool

func set_new_frame(new_frame : int):
	if is_last == false:
		next_tooth.set_new_frame(frame)
	frame = new_frame
