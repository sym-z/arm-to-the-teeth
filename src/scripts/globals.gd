extends Node

var debug : bool = false
var debug_combat : bool = true
var verbose_console : bool = false

const NORTH : int = 8
const SOUTH : int = 4
const WEST : int = 2
const EAST : int = 1

# What floor is the player on?
var curr_floor = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

## In case I need to get reverse directions
func get_opposite_direction(d:int):
	match d:
		Globals.NORTH:
			return Globals.SOUTH
		Globals.SOUTH:
			return Globals.NORTH
		Globals.WEST:
			return Globals.EAST
		Globals.EAST:
			return Globals.WEST

func left_of(d:int):
	match d:
		Globals.NORTH:
			return Globals.WEST
		Globals.SOUTH:
			return Globals.EAST
		Globals.WEST:
			return Globals.SOUTH
		Globals.EAST:
			return Globals.NORTH

func right_of(d:int):
	match d:
		Globals.NORTH:
			return Globals.EAST
		Globals.SOUTH:
			return Globals.WEST
		Globals.WEST:
			return Globals.NORTH
		Globals.EAST:
			return Globals.SOUTH
			

	
