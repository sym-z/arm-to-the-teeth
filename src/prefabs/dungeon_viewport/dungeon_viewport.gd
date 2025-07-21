extends Node2D

@export var map : Node
@export var player : Node

enum CENTER {WALL, EMPTY}
enum SIDE {WALL, TURN, EMPTY}
## Wall Sprites
## d0
## TODO: DELETE THESE 2 LINES
enum D0_CENTER {WALL,EMPTY}
enum D0_SIDE {WALL, TURN, EMPTY}

@export_category("D0 Walls")
@export var d0_left : AnimatedSprite2D
@export var d0_center : AnimatedSprite2D
@export var d0_right : AnimatedSprite2D
var d0_walls : Dictionary[String,AnimatedSprite2D] = {
	"left" : d0_left,
	"center" : d0_center,
	"right" : d0_right,
}
@export_category("D1 Walls")
@export var d1_f_left : AnimatedSprite2D
@export var d1_l_center : AnimatedSprite2D
@export var d1_left : AnimatedSprite2D
@export var d1_center : AnimatedSprite2D
@export var d1_r_center : AnimatedSprite2D
@export var d1_right : AnimatedSprite2D
@export var d1_f_right : AnimatedSprite2D

@export_category("D2 Walls")
@export var d2_f_left : AnimatedSprite2D
@export var d2_l_center : AnimatedSprite2D
@export var d2_left : AnimatedSprite2D
@export var d2_center : AnimatedSprite2D
@export var d2_r_center : AnimatedSprite2D
@export var d2_right : AnimatedSprite2D
@export var d2_f_right : AnimatedSprite2D
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_map_map_generated():
	refresh_viewport()

func _on_player_change_facing():
	refresh_viewport()

func _on_player_change_position():
	refresh_viewport()

func refresh_viewport():
	#region D0 Render
	# Is there a wall in front of us at d0:
	# Get the cell the player is in
	var curr_cell : Cell = map.world_map[player.position]
	var d0_draw_config = get_cell_draw_config(curr_cell,player.facing)
	d0_center.frame = d0_draw_config[0]
	d0_left.frame = d0_draw_config[1]
	d0_right.frame = d0_draw_config[2]
	#endregion
	#region D1 Render
	# If there isn't a wall in front of us, get the draw config for the cell in front of us.
	if d0_center.frame == CENTER.EMPTY:
		# Get the draw config for the cell in front of the player
		var d1_center_draw_config = get_cell_draw_config(map.get_forward_cell(player.position,player.facing), player.facing)
		d1_center.frame = d1_center_draw_config[0]
		d1_left.frame = d1_center_draw_config[1]
		# If the side walls are empty, we need to see what lies beyond them.
		if d1_left.frame == SIDE.EMPTY:
			var d1_left_draw_config = get_cell_draw_config(map.get_forward_cell(map.get_left_cell(player.position,player.facing).position,player.facing), player.facing)
			d1_l_center.frame = d1_left_draw_config[0]
			d1_f_left.frame = d1_left_draw_config[1]
		d1_right.frame = d1_center_draw_config[2]
		if d1_right.frame == SIDE.EMPTY:
			var d1_right_draw_config = get_cell_draw_config(map.get_forward_cell(map.get_right_cell(player.position,player.facing).position,player.facing), player.facing)
			d1_r_center.frame = d1_right_draw_config[0]
			d1_f_right.frame = d1_right_draw_config[2]
	# If there is an empty left frame in d0, step forward from the player's adjacent left cell and get the draw config
	if d0_left.frame == SIDE.EMPTY:
		var d1_left_draw_config = get_cell_draw_config(map.get_forward_cell(map.get_left_cell(player.position,player.facing).position,player.facing), player.facing)
		d1_l_center.frame = d1_left_draw_config[0]
		d1_f_left.frame = d1_left_draw_config[1]
	# If there is an empty right frame in d0, step forward from the player's adjacent right cell and get the draw config
	if d0_right.frame == SIDE.EMPTY:
		var d1_right_draw_config = get_cell_draw_config(map.get_forward_cell(map.get_right_cell(player.position,player.facing).position,player.facing), player.facing)
		d1_r_center.frame = d1_right_draw_config[0]
		d1_f_right.frame = d1_right_draw_config[2]
	#endregion
	#region D2 Render
	# First do center piece
	if d1_center.frame == CENTER.EMPTY:
		# Get the draw config for the cell in front of the cell in front of the player
		# First forward cell
		var forward_cell : Cell = map.get_forward_cell(player.position,player.facing)
		# Cell in front of d1 center
		var forward_cell_2 : Cell = map.get_forward_cell(forward_cell.position,player.facing)
		var d2_center_draw_config = get_cell_draw_config(forward_cell_2,player.facing)
		d2_center.frame = d2_center_draw_config[0]
		d2_left.frame = d2_center_draw_config[1]
		d2_right.frame = d2_center_draw_config[2]

# Passes back what is to the center, left, and right of a cell at a given direction
func get_cell_draw_config(c : Cell, facing : int):
	var draw_config : Array[int]
	# Check wall in facing direction
	if c.walls_to_int() & facing:
		draw_config.append(CENTER.WALL)
	else:
		draw_config.append(CENTER.EMPTY)
	# Check sides
	# Left side
	if c.walls_to_int() & Globals.left_of(facing):
		draw_config.append(SIDE.WALL)
	else:
		# Check what is ahead of the left cell in the direction that the player is facing
		# Cannot go out of bounds because this only happens if there is not a wall to our left
		var left_cell : Cell = map.get_left_cell(c.position,facing)
		# Check to see if there is a wall or nothing in the direction the player is facing in this cell
		if left_cell.walls_to_int() & facing:
			draw_config.append(SIDE.TURN)
		else:
			draw_config.append(SIDE.EMPTY)
	# Right side
	if c.walls_to_int() & Globals.right_of(facing):
		draw_config.append(SIDE.WALL)
	else:
		# Check what is ahead of the right cell in the direction that the player is facing
		# Cannot go out of bounds because this only happens if there is not a wall to our right
		var right_cell : Cell = map.get_right_cell(c.position,facing)
		# Check to see if there is a wall or nothing in the direction the player is facing in this cell
		if right_cell.walls_to_int() & facing:
			draw_config.append(SIDE.TURN)
		else:
			draw_config.append(SIDE.EMPTY)
	return draw_config
