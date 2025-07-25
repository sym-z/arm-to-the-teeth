extends Node

@export var position : Vector2i = Vector2i(0,0)
@export var facing : int = Globals.NORTH
@export var map : Node 

signal change_facing
signal change_position
signal item_picked_up
# Allows items/landmarks to be set after the player has spawned.
signal player_spawned
# Sends signal to UI to activate buttons and/or start battle.
signal item_detected(item : Cell.TYPE, loc : Vector2i)
# Inventory
@export var tooth_count : int = 3
# How many arms are equipped
var arm_count : int = 0
const ARM_MAX : int = 2
const TOOTH_MAX : int = 32
var arm_inventory : Array[Arm]

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func give_starting_loadout():
	var starting_arm : Arm = Arm.new()
	# TODO: Randomize
	starting_arm.strength = 1
	starting_arm.condition = 5
	starting_arm.equipped = true
	arm_count += 1
	arm_inventory.append(starting_arm)
func debug_print_inventory():
	print("INVENTORY")
	for i in range(arm_inventory.size()):
		print("ARM ", i+1)
		arm_inventory[i].debug_print()

# After the map has been generated, mark the player's starting position as their spawn point, and give their starting loadout, if it is the first floor.
func _on_map_map_generated():
	if Globals.curr_floor == 0:
		give_starting_loadout()
		debug_print_inventory()
	map.world_map[position].contents = Cell.TYPE.SPAWN
	player_spawned.emit()

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
	check_cell_content()

#region Detecting Cell Types, and Cell Content Interaction
# Sees if the player is standing on anything, enemy, exit, etc.
func check_cell_content() -> Cell.TYPE:
	var curr_cell : Cell = map.world_map[position]
	match curr_cell.contents:
		Cell.TYPE.EMPTY:
			item_detected.emit(Cell.TYPE.EMPTY, position)
			return Cell.TYPE.EMPTY
		Cell.TYPE.EXIT:
			print("PLAYER ON EXIT!")
			item_detected.emit(Cell.TYPE.EXIT, position)
			map.new_level()
			return Cell.TYPE.EXIT
		Cell.TYPE.SPAWN:
			print("PLAYER ON SPAWN!")
			item_detected.emit(Cell.TYPE.SPAWN, position)
			return Cell.TYPE.SPAWN
		Cell.TYPE.ARM:
			print("PLAYER ON ARM!")
			item_detected.emit(Cell.TYPE.ARM, position)
			return Cell.TYPE.ARM
		Cell.TYPE.TOOTH:
			print("PLAYER ON TOOTH!")
			item_detected.emit(Cell.TYPE.TOOTH, position)
			return Cell.TYPE.TOOTH
		Cell.TYPE.ENEMY:
			print("PLAYER ON ENEMY!")
			item_detected.emit(Cell.TYPE.ENEMY, position)
			return Cell.TYPE.ENEMY
	push_error("Current cell does not have detectable type in check_cell_type() in player.gd")
	item_detected.emit(Cell.TYPE.EMPTY, position)
	return Cell.TYPE.EMPTY
	
func pick_up(type : Cell.TYPE):
	var curr_cell : Cell = map.world_map[position]
	match type:
		Cell.TYPE.ARM:
			if arm_count < ARM_MAX:
				# Use the map's list of arms to pick up the arm.
				var new_arm : Arm = map.arm_atlas[position]
				new_arm.equipped = true
				arm_inventory.append(new_arm)
				# Remove from map's tracker of arm inventory
				map.arm_atlas.erase(position)
				# NOTE: Automatically equips, may change this later
				arm_count += 1
				map.make_cell_empty(curr_cell)
				item_picked_up.emit()
				print("PICKED UP ARM! PLAYER NOW HOLDS ", arm_count, " ARMS!")
				debug_print_inventory()
				map.print_arm_atlas()
		Cell.TYPE.TOOTH:
			# Check if the player has room
			if tooth_count < TOOTH_MAX:
				# Add to inventory
				# TODO: Make this a random amount of teeth and give the player the option of picking up
				tooth_count += 1
				map.make_cell_empty(curr_cell)
				item_picked_up.emit()
				print("PICKED UP TOOTH! PLAYER NOW HOLDS ", tooth_count, " TEETH!")
	
#endregion
