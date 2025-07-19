extends Node

var world_map : Dictionary[Vector2i,Cell]
var frontier : Array[Cell]
const ROWS = 3
const COLS = 3
enum DIR{N=1,S=2,W=4,E=8}
func _ready():
	create_map(ROWS,COLS)
	generate_maze()
	print_map()

## Initialize Dictionary for world map
func create_map(row,col):
	for i in range(row):
		for j in range(col):
			var curr_cell = Cell.new()
			curr_cell.position = Vector2i(j,i)
			world_map[curr_cell.position] = curr_cell

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

func print_neighbors(c : Cell, neighbors : Array[Cell]):
	print("PRINTING NEIGHBORS OF ", c.position, " THAT ARE IN THE MAP")
	for n in neighbors:
		print(n.position)
#endregion

# Prim's Algorithm
# Used this site: https://weblog.jamisbuck.org/2011/1/10/maze-generation-prim-s-algorithm to help me learn how it is implemented, and built it in my own way.
func generate_maze():
	# Choose random cell
	var rand_cell : Cell = world_map[Vector2i(randi_range(0,COLS-1), randi_range(0,ROWS-1))]
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
		DIR.N:
			from.s_wall = false
			to.n_wall = false
		DIR.S:
			from.n_wall = false
			to.s_wall = false
		DIR.E:
			from.w_wall = false
			to.e_wall = false
		DIR.W:
			from.e_wall = false
			to.w_wall = false

## Returns array of adjacent Cell locations
func get_adj_locs(c : Cell) -> Array[Vector2i]:
	var top_loc : Vector2i = Vector2i(c.position.x,c.position.y-1)
	var bot_loc : Vector2i = Vector2i(c.position.x,c.position.y+1)
	var l_loc : Vector2i = Vector2i(c.position.x-1,c.position.y)
	var r_loc : Vector2i = Vector2i(c.position.x+1,c.position.y)
	return [top_loc,bot_loc,l_loc,r_loc]

## Checks bounds of a location against map bounds
func check_bounds(loc : Vector2i) -> bool:
	if(loc.x >= 0 and loc.x < COLS and loc.y >= 0 and loc.y < ROWS):
		return true
	return false

## Returns From's direction in relation to To, From must be adjacent to To
func get_direction(from : Cell, to : Cell) -> DIR:
	if from.position.x > to.position.x:
		return DIR.E
	if from.position.x < to.position.x:
		return DIR.W
	if from.position.y > to.position.y:
		return DIR.S
	return DIR.N

## In case I need to get reverse directions
func get_opposite_direction(d:DIR):
	match d:
		DIR.N:
			return DIR.S
		DIR.S:
			return DIR.N
		DIR.W:
			return DIR.E
		DIR.E:
			return DIR.W
