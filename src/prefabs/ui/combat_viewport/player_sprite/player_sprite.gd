extends AnimatedSprite2D


# Should this animation reverse back to 0?
var bounce : bool = true

signal bounce_finished
func _ready():
	connect("animation_finished", bounce_animation)

func attack_bounce():
	animation = "attack"
	frame = 0
	bounce = true
	play()

func hurt_bounce():
	animation = "hurt"
	frame = 0
	bounce = true
	play()
	
func bounce_animation():
	if bounce == true:
		play_backwards(animation)
		bounce = false
	else:
		bounce_finished.emit()
		animation = "default"
		frame = 0
