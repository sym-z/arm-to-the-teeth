extends Node2D

@export var map : Node
@export var player : Node


## Wall Sprites
## d0
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
	# Check wall in facing direction
	if curr_cell.walls_to_int() & player.facing:
		d0_center.frame = D0_CENTER.WALL
	else:
		d0_center.frame = D0_CENTER.EMPTY
	# Check sides
	# Left side
	if curr_cell.walls_to_int() & Globals.left_of(player.facing):
		d0_left.frame = D0_SIDE.WALL
	else:
		# Check what is ahead of the left cell in the direction that the player is facing
		# Cannot go out of bounds because this only happens if there is not a wall to our left
		var left_cell : Cell = map.get_left_cell(player.position,player.facing)
		# Check to see if there is a wall or nothing in the direction the player is facing in this cell
		if left_cell.walls_to_int() & player.facing:
			d0_left.frame = D0_SIDE.TURN
		else:
			d0_left.frame = D0_SIDE.EMPTY
	# Right side
	if curr_cell.walls_to_int() & Globals.right_of(player.facing):
		d0_right.frame = D0_SIDE.WALL
	else:
		# Check what is ahead of the right cell in the direction that the player is facing
		# Cannot go out of bounds because this only happens if there is not a wall to our right
		var right_cell : Cell = map.get_right_cell(player.position,player.facing)
		# Check to see if there is a wall or nothing in the direction the player is facing in this cell
		if right_cell.walls_to_int() & player.facing:
			d0_right.frame = D0_SIDE.TURN
		else:
			d0_right.frame = D0_SIDE.EMPTY
	#endregion
