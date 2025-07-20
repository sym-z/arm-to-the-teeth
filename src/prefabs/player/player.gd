extends Node

@export var position : Vector2i = Vector2i(0,0)
@export var facing : int = Globals.NORTH
@export var map : Node 

signal change_facing
signal change_position
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _input(event):
	if event.is_action_pressed("move_forward"):
		move()
	if event.is_action_pressed("move_back"):
		move(-1)
	if event.is_action_pressed("turn_left"):
		match facing:
			Globals.NORTH:
				facing = Globals.WEST
			Globals.SOUTH:
				facing = Globals.EAST
			Globals.WEST:
				facing = Globals.SOUTH
			Globals.EAST:
				facing = Globals.NORTH
		change_facing.emit()
	if event.is_action_pressed("turn_right"):
		match facing:
			Globals.NORTH:
				facing = Globals.EAST
			Globals.SOUTH:
				facing = Globals.WEST
			Globals.WEST:
				facing = Globals.NORTH
			Globals.EAST:
				facing = Globals.SOUTH
		change_facing.emit()

## Attempts to move in the direwaaction facing, opposite if is_backward is true
func move(distance : int = 1):
	var curr_cell : Cell = map.world_map[position]
	var cell_wall_config : int = curr_cell.walls_to_int()
	# Moving forward
	if distance > 0:
		# Check for a wall ahead
		if cell_wall_config & facing != 0:
			return
	# Moving backward
	else:
		# Check for a wall behind
		if cell_wall_config & Globals.get_opposite_direction(facing) != 0:
			return
	match facing:
		Globals.NORTH:
			position = Vector2i(position.x,position.y-distance)
		Globals.SOUTH:
			position = Vector2i(position.x,position.y+distance)
		Globals.WEST:
			position = Vector2i(position.x-distance, position.y)
		Globals.EAST:
			position = Vector2i(position.x+distance, position.y)
	change_position.emit()
