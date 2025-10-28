extends AnimatedSprite2D

@export var prev_tooth : AnimatedSprite2D
@export var next_tooth : AnimatedSprite2D

@export var is_first : bool
@export var is_last : bool

enum TYPE{MISS = 0, HIT = 1, WHIFF = 2}

func set_new_frame(new_frame : int, anim : String = "default"):
	if is_last == false:
		# Set next tooth's animation to be broken or not
		if animation == "broken":
			next_tooth.set_new_frame(frame, "broken")
		else:
			next_tooth.set_new_frame(frame)
	animation = anim
	frame = new_frame
	if animation == "broken":
		print(new_frame, frame, animation)
