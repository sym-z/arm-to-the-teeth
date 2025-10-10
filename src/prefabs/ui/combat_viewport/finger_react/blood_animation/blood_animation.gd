extends AnimatedSprite2D


# Called when the node enters the scene tree for the first time.
func _ready():
	visible = false
	pass # Replace with function body.


func cut_middle():
	animation = "middle"
	visible = true
	play()


func cut_left():
	animation = "left"
	visible = true
	play()


func cut_right():
	animation = "right"
	visible = true
	play()
