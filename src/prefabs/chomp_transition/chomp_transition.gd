extends AnimatedSprite2D

var transition_scene : Callable

func open():
	animation = "open"
	frame = 0
	play()
	
	
func close(transition : Callable):
	transition_scene = transition
	animation = "close"
	frame = 0
	play()

func _on_animation_finished():
	if animation == "close":
		transition_scene.call()
