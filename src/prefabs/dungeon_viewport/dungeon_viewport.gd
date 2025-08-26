extends Node2D

@export var map : Node
@export var player : Node

enum CENTER {WALL, EMPTY}
enum SIDE {WALL, TURN, EMPTY}
## Wall Sprites
@export_category("D0 Walls")
@export var d0_left : AnimatedSprite2D
@export var d0_center : AnimatedSprite2D
@export var d0_right : AnimatedSprite2D

@export_category("D1 Walls")
@export var d1_f_left : AnimatedSprite2D
@export var d1_l_center : AnimatedSprite2D
@export var d1_left : AnimatedSprite2D
@export var d1_center : AnimatedSprite2D
@export var d1_r_center : AnimatedSprite2D
@export var d1_right : AnimatedSprite2D
@export var d1_f_right : AnimatedSprite2D

@export_category("D2 Walls")
@export var d2_fff_left : AnimatedSprite2D
@export var d2_ff_left_center : AnimatedSprite2D
@export var d2_ff_left : AnimatedSprite2D
@export var d2_f_left_center : AnimatedSprite2D
@export var d2_f_left : AnimatedSprite2D
@export var d2_l_center : AnimatedSprite2D
@export var d2_left : AnimatedSprite2D
@export var d2_center : AnimatedSprite2D
@export var d2_r_center : AnimatedSprite2D
@export var d2_right : AnimatedSprite2D
@export var d2_f_right : AnimatedSprite2D
@export var d2_f_right_center : AnimatedSprite2D
@export var d2_ff_right : AnimatedSprite2D
@export var d2_ff_right_center : AnimatedSprite2D
@export var d2_fff_right : AnimatedSprite2D

@export_category("Parents")
@export var d0_parent : Node2D
@export var d1_parent : Node2D
@export var d2_parent : Node2D
var d_parents : Array[Node2D] = []

signal refresh_ordering

func _ready():
	d_parents = [d0_parent,d1_parent,d2_parent]
	change_animations("default")

func change_animations(anim : String):
	for parent in d_parents:
		for child in parent.get_children():
			if child.is_in_group("wall"):
				child.animation = anim
	refresh()

func _input(event):
	if event.is_action_pressed("debug_default_tex"):
		change_animations("default")
	elif event.is_action_pressed("debug_tex_0"):
		change_animations("tex_0")
#func _on_map_map_generated():
	#refresh_viewport_2()

func _on_player_change_facing():
	refresh()

func _on_player_change_position():
	refresh()

func _on_player_item_picked_up():
	refresh()

func _on_map_map_filled():
	refresh()

func _on_player_item_partial_pickup():
	refresh()


func refresh():
	refresh_viewport_2()
	refresh_ordering.emit()

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
	# First forward cell
	var d1_center_cell : Cell = map.get_forward_cell(player.position,player.facing)
	# Cell in front of d1 center, d2_center
	var d2_center_cell : Cell
	if d1_center_cell != null:
		d2_center_cell = map.get_forward_cell(d1_center_cell.position,player.facing)
	if d2_center_cell != null:
		if d1_center.frame == CENTER.EMPTY:
			# Get the draw config for the cell in front of the cell in front of the player
			var d2_center_draw_config = get_cell_draw_config(d2_center_cell,player.facing)
			d2_center.frame = d2_center_draw_config[0]
			d2_left.frame = d2_center_draw_config[1]
			# Refresh if side of center is empty
			if d2_left.frame == SIDE.EMPTY:
				var d2_left_cell : Cell = map.get_left_cell(d2_center_cell.position,player.facing)
				var d2_left_draw_config = get_cell_draw_config(d2_left_cell, player.facing)
				d2_l_center.frame = d2_left_draw_config[0]
				d2_f_left.frame = d2_left_draw_config[1]
			# Same for other side
			d2_right.frame = d2_center_draw_config[2]
			if d2_right.frame == SIDE.EMPTY:
				var d2_right_cell : Cell = map.get_right_cell(d2_center_cell.position, player.facing)
				var d2_right_draw_config = get_cell_draw_config(d2_right_cell, player.facing)
				d2_r_center.frame = d2_right_draw_config[0]
				d2_f_right.frame = d2_right_draw_config[2]
		# Refresh what lies beyond if d1's side wall is empty
		if d1_left.frame == SIDE.EMPTY:
			var d2_left_cell : Cell = map.get_left_cell(d2_center_cell.position,player.facing)
			var d2_left_draw_config = get_cell_draw_config(d2_left_cell, player.facing)
			d2_l_center.frame = d2_left_draw_config[0]
			d2_f_left.frame = d2_left_draw_config[1]
		if d1_right.frame == SIDE.EMPTY:
			var d2_right_cell : Cell = map.get_right_cell(d2_center_cell.position, player.facing)
			var d2_right_draw_config = get_cell_draw_config(d2_right_cell, player.facing)
			d2_r_center.frame = d2_right_draw_config[0]
			d2_f_right.frame = d2_right_draw_config[2]
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
	
func refresh_viewport_2():
	# NEW TACTIC: Just refresh everything in bounds every time.
	# Grab all center cells that are in bounds then get all draw configs
	#region Initialize Cells that will be Queried
	var d0_center_cell : Cell = null
	var d1_center_cell : Cell = null
	var d1_left_center_cell : Cell  = null
	var d1_right_center_cell : Cell  = null
	var d2_center_cell : Cell  = null
	var d2_left_center_cell : Cell  = null
	var d2_right_center_cell : Cell  = null
	var d2_f_left_center_cell : Cell  = null
	var d2_f_right_center_cell : Cell  = null
	var d2_ff_left_center_cell : Cell = null
	var d2_ff_right_center_cell : Cell = null
	#endregion
	#region Check Bounds of Cells that I Need the Config Of
	# D0 Center
	var d0_center_loc : Vector2i = player.position
	if map.check_bounds(d0_center_loc):
		d0_center_cell = map.world_map[player.position]
	# D1 Center
	var d1_center_loc : Vector2i = map.get_loc_in_dir(d0_center_loc, player.facing)
	if map.check_bounds(d1_center_loc):
		d1_center_cell = map.world_map[d1_center_loc]
	# D1 Left Center
	var d1_left_center_loc : Vector2i = map.get_loc_in_dir(d1_center_loc, Globals.left_of(player.facing))
	if map.check_bounds(d1_left_center_loc):
		d1_left_center_cell = map.world_map[d1_left_center_loc]
	# D1 Right Center
	var d1_right_center_loc : Vector2i = map.get_loc_in_dir(d1_center_loc, Globals.right_of(player.facing))
	if map.check_bounds(d1_right_center_loc):
		d1_right_center_cell = map.world_map[d1_right_center_loc]
	# D2 Center
	var d2_center_loc : Vector2i = map.get_loc_in_dir(d1_center_loc, player.facing)
	if map.check_bounds(d2_center_loc):
		d2_center_cell = map.world_map[d2_center_loc]
	# D2 Left Center
	var d2_left_center_loc : Vector2i = map.get_loc_in_dir(d2_center_loc, Globals.left_of(player.facing))
	if map.check_bounds(d2_left_center_loc):
		d2_left_center_cell = map.world_map[d2_left_center_loc]
	# D2 Right Center
	var d2_right_center_loc : Vector2i = map.get_loc_in_dir(d2_center_loc, Globals.right_of(player.facing))
	if map.check_bounds(d2_right_center_loc):
		d2_right_center_cell = map.world_map[d2_right_center_loc]
	# D2 Far Left Center
	var d2_f_left_center_loc : Vector2i = map.get_loc_in_dir(d2_left_center_loc, Globals.left_of(player.facing))
	if map.check_bounds(d2_f_left_center_loc):
		d2_f_left_center_cell = map.world_map[d2_f_left_center_loc]
	# D2 Far Right Center
	var d2_f_right_center_loc : Vector2i = map.get_loc_in_dir(d2_right_center_loc, Globals.right_of(player.facing))
	if map.check_bounds(d2_f_right_center_loc):
		d2_f_right_center_cell = map.world_map[d2_f_right_center_loc]
	# D2 Farther Left Center
	var d2_ff_left_center_loc : Vector2i = map.get_loc_in_dir(d2_f_left_center_loc, Globals.left_of(player.facing))
	if map.check_bounds(d2_ff_left_center_loc):
		d2_ff_left_center_cell = map.world_map[d2_ff_left_center_loc]
	# D2 Farther Right Center
	var d2_ff_right_center_loc : Vector2i = map.get_loc_in_dir(d2_f_right_center_loc, Globals.right_of(player.facing))
	if map.check_bounds(d2_ff_right_center_loc):
		d2_ff_right_center_cell = map.world_map[d2_ff_right_center_loc]
	#endregion
	# At this point, all valid cells will not be null
	#region Get Draw Config of All Cells that are Valid, and Apply it to the Animated Sprites, and reveal contents
	# D0 Center Refresh (d0_center,d0_left,d0_right)
	if d0_center_cell != null:
		var d0_c_draw_config = get_cell_draw_config(d0_center_cell,player.facing)
		d0_center.frame = d0_c_draw_config[0]
		reveal_cell_contents(d0_center_cell,d0_center)
		d0_left.frame = d0_c_draw_config[1]
		d0_right.frame = d0_c_draw_config[2]
	# D1 Center Refresh (d1_center,d1_left,d1_right)
	if d1_center_cell != null:
		var d1_c_draw_config = get_cell_draw_config(d1_center_cell,player.facing)
		d1_center.frame = d1_c_draw_config[0]
		reveal_cell_contents(d1_center_cell,d1_center)
		d1_left.frame = d1_c_draw_config[1]
		d1_right.frame = d1_c_draw_config[2]
	# D1 Left Center Refresh (d1_l_center, d1_f_left)
	if d1_left_center_cell != null:
		var d1_lc_draw_config = get_cell_draw_config(d1_left_center_cell,player.facing)
		d1_l_center.frame = d1_lc_draw_config[0]
		reveal_cell_contents(d1_left_center_cell,d1_l_center)
		d1_f_left.frame = d1_lc_draw_config[1]
	# D1 Right Center Refresh (d1_r_center, d1_f_right)
	if d1_right_center_cell != null:
		var d1_rc_draw_config = get_cell_draw_config(d1_right_center_cell,player.facing)
		d1_r_center.frame = d1_rc_draw_config[0]
		reveal_cell_contents(d1_right_center_cell,d1_r_center)
		d1_f_right.frame = d1_rc_draw_config[2]
	# D2 Center Refresh (d2_center,d2_left,d2_right)
	if d2_center_cell != null:
		var d2_c_draw_config = get_cell_draw_config(d2_center_cell,player.facing)
		d2_center.frame = d2_c_draw_config[0]
		reveal_cell_contents(d2_center_cell,d2_center)
		d2_left.frame = d2_c_draw_config[1]
		d2_right.frame = d2_c_draw_config[2]
	# D2 Left Center Refresh (d2_l_center, d2_f_left)
	if d2_left_center_cell != null:
		var d2_lc_draw_config = get_cell_draw_config(d2_left_center_cell,player.facing)
		d2_l_center.frame = d2_lc_draw_config[0]
		reveal_cell_contents(d2_left_center_cell,d2_l_center)
		d2_f_left.frame = d2_lc_draw_config[1]
	# D2 Right Center Refresh (d2_r_center, d2_f_right)
	if d2_right_center_cell != null:
		var d2_rc_draw_config = get_cell_draw_config(d2_right_center_cell,player.facing)
		d2_r_center.frame = d2_rc_draw_config[0]
		reveal_cell_contents(d2_right_center_cell,d2_r_center)
		d2_f_right.frame = d2_rc_draw_config[2]
	# D2 Far Left Center Refresh (d2_f_left_center,d2_ff_left)
	if d2_f_left_center_cell != null:
		var d2_flc_draw_config = get_cell_draw_config(d2_f_left_center_cell, player.facing)
		d2_f_left_center.frame = d2_flc_draw_config[0]
		reveal_cell_contents(d2_f_left_center_cell,d2_f_left_center)
		d2_ff_left.frame = d2_flc_draw_config[1]
	# D2 Far Right Center Refresh (d2_f_right_center,d2_ff_right)
	if d2_f_right_center_cell != null:
		var d2_frc_draw_config = get_cell_draw_config(d2_f_right_center_cell, player.facing)
		d2_f_right_center.frame = d2_frc_draw_config[0]
		reveal_cell_contents(d2_f_right_center_cell,d2_f_right_center)
		d2_ff_right.frame = d2_frc_draw_config[2]
	# D2 Farther Left Center Refresh (d2_ff_left_center,d2_fff_left)
	if d2_ff_left_center_cell != null:
		var d2_fflc_draw_config = get_cell_draw_config(d2_ff_left_center_cell, player.facing)
		d2_ff_left_center.frame = d2_fflc_draw_config[0]
		reveal_cell_contents(d2_ff_left_center_cell,d2_ff_left_center)
		d2_fff_left.frame = d2_fflc_draw_config[1]
	# D2 Farther Right Center Refresh (d2_ff_right_center,d2_fff_right)
	if d2_ff_right_center_cell != null:
		var d2_ffrc_draw_config = get_cell_draw_config(d2_ff_right_center_cell, player.facing)
		d2_ff_right_center.frame = d2_ffrc_draw_config[0]
		reveal_cell_contents(d2_ff_right_center_cell,d2_ff_right_center)
		d2_fff_right.frame = d2_ffrc_draw_config[2]
	#endregion

# Reveals content of "c" using the child of the sprite, "sprite"
func reveal_cell_contents(c : Cell, sprite : AnimatedSprite2D):
	if sprite.get_children().size() == 0:
		push_error("Attempted to reveal content of non-applicable sprite in dungeon_viewport, reveal_cell_contents()")
		return
	var content_sprite : AnimatedSprite2D = sprite.get_child(0)
	match c.contents:
		Cell.TYPE.EXIT:
			content_sprite.animation = "exit"
			content_sprite.visible = true
			content_sprite.play()
		Cell.TYPE.ARM:
			content_sprite.animation = "arm"
			content_sprite.visible = true
			content_sprite.play()
		Cell.TYPE.TOOTH:
			content_sprite.animation = "tooth"
			content_sprite.visible = true
			content_sprite.play()
		Cell.TYPE.ENEMY:
			content_sprite.animation = "enemy"
			content_sprite.visible = true
			content_sprite.play()
		Cell.TYPE.CHEST:
			content_sprite.animation = "chest"
			content_sprite.visible = true
			content_sprite.play()
		Cell.TYPE.KEY:
			content_sprite.animation = "key"
			content_sprite.visible = true
			content_sprite.play()
		_:
			content_sprite.visible = false
