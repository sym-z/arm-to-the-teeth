extends AnimatedSprite2D
@export var wall_to_check : AnimatedSprite2D
@export var root_parent : Node2D

func _ready():
	# When the state of the world changes, make sure that items are layered properly
	wall_to_check.connect("frame_changed", adjust_ordering)
	root_parent.connect("refresh_ordering", adjust_ordering)

func adjust_ordering():
	if wall_to_check.frame != 0:
		#z_index = wall_to_check.z_index (This would make the z_index = parent z + wall to check z which is too much
		# Adding 1 makes the ordering effectively be the same z_index as the wall it is checking
		# 0 = same z as parent, 1 = same z as wall to check, 2 = one above the z_index of wall to check
		z_index = 2
	else:
		z_index = 0
