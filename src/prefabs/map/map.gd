extends Node

var world_map : Dictionary[Vector2i,Cell]
var frontier : Array[Cell]
@export var rows : int = 10
@export var cols : int = 10

## Used to ensure visualization after computation
signal map_generated
## Ensure visualization after finalization of item dispersion.
signal map_filled
func _ready():
	if Globals.debug == false:
		create_map(rows,cols)
		generate_maze()
	else:
		create_debug_map(rows,cols)
	#print_map()

## Initialize Dictionary for world map
func create_map(row,col):
	for i in range(row):
		for j in range(col):
			var curr_cell = Cell.new()
			curr_cell.position = Vector2i(j,i)
			world_map[curr_cell.position] = curr_cell

func create_debug_map(row, col):
	# Remember to send map generated signal
	# Creates a map with walls around the boundaries, with a single pillar in the middle
	var center_loc : Vector2i = Vector2i(row/2,col/2)
	var left_loc : Vector2i = Vector2i(center_loc.x-1,center_loc.y)
	var right_loc : Vector2i = Vector2i(center_loc.x+1,center_loc.y)
	var up_loc : Vector2i = Vector2i(center_loc.x,center_loc.y-1)
	var down_loc : Vector2i = Vector2i(center_loc.x,center_loc.y+1)
	for i in range(row):
		for j in range(col):
			var curr_cell = Cell.new()
			curr_cell.e_wall = false
			curr_cell.w_wall = false
			curr_cell.n_wall = false
			curr_cell.s_wall = false
			curr_cell.position = Vector2i(j,i)
			if curr_cell.position == center_loc:
				curr_cell.e_wall = true
				curr_cell.w_wall = true
				curr_cell.n_wall = true
				curr_cell.s_wall = true
			elif curr_cell.position == left_loc:
				curr_cell.e_wall = true
			elif curr_cell.position == right_loc:
				curr_cell.w_wall = true
			elif curr_cell.position == up_loc:
				curr_cell.s_wall = true
			elif curr_cell.position == down_loc:
				curr_cell.n_wall = true
			if curr_cell.position.y == 0:
				curr_cell.n_wall = true
			if curr_cell.position.y == row-1:
				curr_cell.s_wall = true
			if curr_cell.position.x == 0:
				curr_cell.w_wall = true
			if curr_cell.position.x == col-1:
				curr_cell.e_wall = true 
			world_map[curr_cell.position] = curr_cell
	map_generated.emit()

#region Printing Functions
func print_map():
	print("PRINTING MAP")
	for key in world_map.keys():
		print_cell(world_map[key])

func print_frontier():
	print("PRINTING FRONTIER")
	for cell in frontier:
		print_cell(cell)

func print_cell(c: Cell):
	print("POS: ", c.position, " IN MAZE?: ", c.in_maze, " WALLS:")
	print("N: ", c.n_wall)
	print("S: ", c.s_wall)
	print("W: ", c.w_wall)
	print("E: ", c.e_wall)
	print("WALL NO: ", c.walls_to_int())

func print_neighbors(c : Cell, neighbors : Array[Cell]):
	print("PRINTING NEIGHBORS OF ", c.position, " THAT ARE IN THE MAP")
	for n in neighbors:
		print(n.position)
#endregion
#region Prim's Algorithm
# Prim's Algorithm
# Used this site: https://weblog.jamisbuck.org/2011/1/10/maze-generation-prim-s-algorithm to help me learn how it is implemented, and built it in my own way.
func generate_maze():
	# Choose random cell
	var rand_cell : Cell = world_map[Vector2i(randi_range(0,cols-1), randi_range(0,rows-1))]
	# Add it to the maze (mark it)
	mark(rand_cell)
	while frontier.size() > 0:
		# Pop a random frontier cell
		var curr_cell : Cell = frontier.pop_at(randi_range(0,frontier.size()-1))
		# Grab all neighbors of that cell that are currently in the maze
		var neighbors : Array[Cell] = grab_neighbors(curr_cell)
		# Choose a random neighbor and connect them together
		var rand_neighbor = neighbors[randi_range(0,neighbors.size()-1)]
		connect_cells(curr_cell, rand_neighbor)
		# Mark this frontier cell as in the maze and add its adjacent cells to the frontier
		mark(curr_cell)
	map_generated.emit()

func mark(c : Cell):
	c.in_maze = true
	# Add its surrounding cells to the frontier (idk if it has to be checked if they are in the maze already, doing it anyway)
	add_adj_to_frontier(c)

func add_adj_to_frontier(c : Cell):
	for loc in get_adj_locs(c):
		# If the cell is within bounds, not a part of the map, and not already in the frontier, add it to the frontier
		if(check_bounds(loc) == true and world_map[loc].in_maze == false and frontier.find(world_map[loc]) == -1):
			frontier.append(world_map[loc])

## Grabs adjacent cells that are in the maze
func grab_neighbors(c : Cell) ->  Array[Cell]:
	var neighbors : Array[Cell] = []
	for loc in get_adj_locs(c):
		if check_bounds(loc) == true and world_map[loc].in_maze == true:
			neighbors.append(world_map[loc])
	return neighbors

## Connect From to To and To to From
func connect_cells(from : Cell, to : Cell):
	# Get from's direction in relation to to, and demolish their respective walls
	match get_direction(from,to):
		# From is north of To, destroy From's south wall, and To's north wall
		Globals.NORTH:
			from.s_wall = false
			to.n_wall = false
		Globals.SOUTH:
			from.n_wall = false
			to.s_wall = false
		Globals.EAST:
			from.w_wall = false
			to.e_wall = false
		Globals.WEST:
			from.e_wall = false
			to.w_wall = false
#endregion
#region Grabbing Cells and Checking Locations
## Returns array of adjacent Cell locations
func get_adj_locs(c : Cell) -> Array[Vector2i]:
	var top_loc : Vector2i = Vector2i(c.position.x,c.position.y-1)
	var bot_loc : Vector2i = Vector2i(c.position.x,c.position.y+1)
	var l_loc : Vector2i = Vector2i(c.position.x-1,c.position.y)
	var r_loc : Vector2i = Vector2i(c.position.x+1,c.position.y)
	return [top_loc,bot_loc,l_loc,r_loc]

## Checks bounds of a location against map bounds
func check_bounds(loc : Vector2i) -> bool:
	if(loc.x >= 0 and loc.x < cols and loc.y >= 0 and loc.y < rows):
		return true
	return false

## Returns From's direction in relation to To, From must be adjacent to To
func get_direction(from : Cell, to : Cell) -> int:
	if from.position.x > to.position.x:
		return Globals.EAST
	if from.position.x < to.position.x:
		return Globals.WEST
	if from.position.y > to.position.y:
		return Globals.SOUTH
	return Globals.NORTH

# Returns a coord in a given direction
func get_loc_in_dir(curr_loc : Vector2i, dir : int):
	match dir:
		Globals.NORTH:
			return Vector2i(curr_loc.x,curr_loc.y-1)
		Globals.SOUTH:
			return Vector2i(curr_loc.x,curr_loc.y+1)
		Globals.WEST:
			return Vector2i(curr_loc.x-1,curr_loc.y)
		Globals.EAST:
			return Vector2i(curr_loc.x+1,curr_loc.y)

# Returns the cell to the left of a current location, taking into account a facing direction
func get_left_cell(curr_loc : Vector2i, facing : int):
	var left_dir : int = Globals.left_of(facing)
	if check_bounds(get_loc_in_dir(curr_loc,left_dir)):
		return world_map[get_loc_in_dir(curr_loc,left_dir)]
	else:
		return null

# Returns the cell to the right of a current location, taking into account a facing direction
func get_right_cell(curr_loc : Vector2i, facing : int):
	var right_dir : int = Globals.right_of(facing)
	if check_bounds(get_loc_in_dir(curr_loc,right_dir)):
		return world_map[get_loc_in_dir(curr_loc,right_dir)]
	else:
		return null

# Returns the cell one cell forward in the direction that the player is facing
func get_forward_cell(curr_loc: Vector2i, facing: int):
	if check_bounds(get_loc_in_dir(curr_loc,facing)):
		return world_map[get_loc_in_dir(curr_loc,facing)]
	else:
		return null
#endregion
# Once the player spawns, items/landmarks can be generated.
func _on_player_player_spawned():
	place_exit()
	# Place Items
	# Place Enemies
	map_filled.emit()

func place_exit():
	# Grab a random spot on the map, and mark it as an exit.
	var exit_chosen : bool = false
	while exit_chosen == false:
		var rand_loc : Vector2i = Vector2i(randi_range(0,rows-1), randi_range(0,cols-1))
		if world_map[rand_loc].contents == Cell.TYPE.EMPTY:
			world_map[rand_loc].contents = Cell.TYPE.EXIT
			exit_chosen = true
