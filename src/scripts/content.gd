extends AnimatedSprite2D
@export var wall_to_check : AnimatedSprite2D
@export var root_parent : Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	# When the state of the world changes, make sure that items are layered properly
	wall_to_check.connect("frame_changed", adjust_ordering)
	root_parent.connect("refresh_ordering", adjust_ordering)
	pass # Replace with function body.

func adjust_ordering():
	if wall_to_check.frame != 0:
		z_index = 1
	else:
		z_index = 0
	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
