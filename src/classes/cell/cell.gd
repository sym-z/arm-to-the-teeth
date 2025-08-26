class_name Cell extends Resource

var position : Vector2i

## What is stored in this cell?
enum TYPE {EMPTY, SPAWN, EXIT, ARM, TOOTH, ENEMY, CHEST, KEY}
var contents : TYPE = TYPE.EMPTY
## If this spot is a TOOTH type, how many teeth does it hold?
var tooth_count : int = 0
## Wall Configuration
# TODO: Convert these into single bitwise integer
var n_wall : bool = true
var s_wall : bool = true
var e_wall : bool = true
var w_wall : bool = true

## Maze Status
var in_maze : bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func walls_to_int() -> int:
	var wall_config = 0
	if n_wall == true:
		wall_config |= Globals.NORTH
	if s_wall == true:
		wall_config |= Globals.SOUTH
	if w_wall == true:
		wall_config |= Globals.WEST
	if e_wall == true:
		wall_config |= Globals.EAST
	return wall_config

func dir_to_wall(d : int) -> bool:
	match d:
		Globals.NORTH:
			return n_wall
		Globals.SOUTH:
			return s_wall
		Globals.WEST:
			return w_wall
		Globals.EAST:
			return e_wall
	return false
