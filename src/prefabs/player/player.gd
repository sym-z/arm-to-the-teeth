extends Node

@export var position : Vector2i = Vector2i(0,0)
@export var facing : int = Globals.NORTH
@export var map : Node 
@export var ui : CanvasLayer
@export var speaker : AudioStreamPlayer
## Will the player enter the battle scene when they step on a space with an enemy
var ignore_combat : bool = Globals.ignore_combat
## Is the player currently in combat
var in_combat : bool = false
var holding_key : bool = false
var disable_movement : bool = false

signal change_facing
signal change_position
signal item_picked_up
signal item_partial_pickup
# Allows items/landmarks to be set after the player has spawned.
signal player_spawned
# Sends signal to UI to activate buttons
signal item_detected(item : Cell.TYPE, loc : Vector2i)
signal combat_started(enemy: Enemy, loc : Vector2i)
#region Inventory and Stat Variables
# How many arms are equipped
var arm_count : int = 0
const ARM_MAX : int = 2
var arm_inventory : Array[Arm]
var head : Head 
## Hunger Stats
var hunger : int = 0
enum HUNGER_LEVEL {SATISFIED = 0,HUNGRY = 50, STARVING = 100, DEAD = 150}
var arm_nurishment_min : int = 10
var arm_nurishment_max : int = 30
var hunger_state : HUNGER_LEVEL = HUNGER_LEVEL.SATISFIED
var attack_debuff : float = 1.0
var death_steps : int = 0
const HUNGER_DAMAGE_TICK : int = 10
signal hunger_ticked
# For connecting the UI in the future to show specific states of hunger.
signal hunger_satisfied
signal hunger_hungry
signal hunger_starving
signal hunger_dead
# For refreshing UI
signal stat_change
#endregion

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func give_starting_loadout():
	head = Head.new()
	var starting_arm : Arm = Arm.new()
	# TODO: Randomize
	starting_arm.strength = 1
	starting_arm.max_condition = 5
	starting_arm.condition = starting_arm.max_condition
	starting_arm.equipped = true
	arm_count += 1
	arm_inventory.append(starting_arm)
	if Globals.debug_combat:
		var power_arm : Arm = Arm.new()
		power_arm.strength = 100
		power_arm.max_condition = 100
		power_arm.condition = power_arm.max_condition
		power_arm.equipped = true
		arm_count += 1
		arm_inventory.append(power_arm)
func debug_print_inventory():
	print("INVENTORY")
	for i in range(arm_inventory.size()):
		print("ARM ", i+1)
		arm_inventory[i].debug_print()

# After the map has been generated, mark the player's starting position as their spawn point, and give their starting loadout, if it is the first floor.
func _on_map_map_generated():
	if Globals.curr_floor == 0:
		give_starting_loadout()
		if Globals.verbose_console == true:
			debug_print_inventory()
	else:
		upgrade_loadout()
	if holding_key == true:
		Log.add_log_message("IT DROPPED IT'S KEY TO THE LAST FLOOR'S CHEST.")
	holding_key = false
	ui.key_slot.visible = false
	map.world_map[position].contents = Cell.TYPE.SPAWN
	player_spawned.emit()

# Each floor, the player can upgrade something. For now, their head max_health and current health goes up by one each floor. 
func upgrade_loadout():
	head.max_health += 1
	head.health += 1
	Log.add_log_message("IT GREW STRONGER, ITS HEAD GAINED BIOTIC FORTITUDE.")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
#region Player Movement
func _input(event):
	if in_combat == false and disable_movement == false:
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
	if event.is_action_pressed("debug_add_hunger"):
		hunger = min(HUNGER_LEVEL.DEAD, hunger+25)
		hunger_ticked.emit()
		set_hunger_state()

	if event.is_action_pressed("debug_sub_hunger"):
		hunger = max(hunger - 25,0)
		hunger_ticked.emit()
		set_hunger_state()

func force_turn_left():
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
	
func force_turn_right():
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
	pass
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
			tick_hunger()
		Globals.SOUTH:
			position = Vector2i(position.x,position.y+distance)
			tick_hunger()
		Globals.WEST:
			position = Vector2i(position.x-distance, position.y)
			tick_hunger()
		Globals.EAST:
			position = Vector2i(position.x+distance, position.y)
			tick_hunger()
	#NOTE: This fires even if the player is blocked by a wall, not sure if that matters.
	change_position.emit()
	check_cell_content()
	AudioBank.play_rand(ui.speaker,AudioBank.BANK.FOOTSTEP)
#endregion

#region Detecting Cell Types, and Cell Content Interaction
# Sees if the player is standing on anything, enemy, exit, etc.
func check_cell_content() -> Cell.TYPE:
	var curr_cell : Cell = map.world_map[position]
	match curr_cell.contents:
		Cell.TYPE.EMPTY:
			item_detected.emit(Cell.TYPE.EMPTY, position)
			return Cell.TYPE.EMPTY
		Cell.TYPE.EXIT:
			if Globals.verbose_console == true:
				print("PLAYER ON EXIT!")
			item_detected.emit(Cell.TYPE.EXIT, position)
			return Cell.TYPE.EXIT
		Cell.TYPE.SPAWN:
			if Globals.verbose_console == true:
				print("PLAYER ON SPAWN!")
			item_detected.emit(Cell.TYPE.SPAWN, position)
			return Cell.TYPE.SPAWN
		Cell.TYPE.ARM:
			if Globals.verbose_console == true:
				print("PLAYER ON ARM!")
			item_detected.emit(Cell.TYPE.ARM, position)
			return Cell.TYPE.ARM
		Cell.TYPE.TOOTH:
			if Globals.verbose_console == true:
				print("PLAYER ON TOOTH!")
			item_detected.emit(Cell.TYPE.TOOTH, position)
			return Cell.TYPE.TOOTH
		Cell.TYPE.ENEMY:
			if Globals.verbose_console == true:
				print("PLAYER ON ENEMY!")
			item_detected.emit(Cell.TYPE.ENEMY, position)
			# Begin combat
			if ignore_combat == false:
				in_combat = true
				combat_started.emit(map.enemy_atlas[position], position)
			return Cell.TYPE.ENEMY
		Cell.TYPE.CHEST:
			item_detected.emit(Cell.TYPE.CHEST, position)
			return Cell.TYPE.CHEST
		Cell.TYPE.KEY:
			item_detected.emit(Cell.TYPE.KEY, position)
			return Cell.TYPE.KEY
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
				# NOTE: Automatically equips, may change this later
				arm_count += 1
				arm_inventory.append(new_arm)
				# Add this arm to the inventory UI
				#ui.add_arm_to_inventory(arm_inventory[arm_inventory.size()-1],arm_count)
				# Remove from map's tracker of arm inventory
				map.arm_atlas.erase(position)
				map.make_cell_empty(curr_cell)
				item_picked_up.emit()
				Log.add_log_message("PICKED UP ARM! IT NOW HOLDS " + str(arm_count) + " ARMS!")
				AudioBank.play_rand(ui.speaker, AudioBank.BANK.ARM_PICKUP)
				if Globals.verbose_console == true:
					debug_print_inventory()
					map.print_arm_atlas()
					print("PICKED UP ARM! PLAYER NOW HOLDS ", arm_count, " ARMS!")
			else:
				# When the player has 2 arms equipped already. To let the player hold arms that are unequipped, add code here.
				# For now, I am only allowing 2 arms to be picked up.
				Log.add_log_message("IT TRIED TO PICK UP AN ARM, BUT IT ALREADY HAS 2 ARMS.")
				pass
		Cell.TYPE.TOOTH:
			# Check if the player has room
			if head.tooth_count < head.TOOTH_MAX:
				# Add to inventory
				# TODO: Make this tied to how much teeth the cell has
				var leftover_teeth : int = head.add_teeth(curr_cell.tooth_count)
				if leftover_teeth == 0:
					map.make_cell_empty(curr_cell)
					item_picked_up.emit()
				else:
					# Need to make sure that UI doesn't mark this spot as empty
					item_partial_pickup.emit()
					curr_cell.tooth_count = leftover_teeth
				AudioBank.play_rand(ui.speaker, AudioBank.BANK.TOOTH_INSERT)
				if Globals.verbose_console == true:
					print("PICKED UP TOOTH! PLAYER NOW HOLDS ", head.tooth_count, " TEETH!")
				#Log.add_log_message("PICKED UP TOOTH! IT NOW HOLDS " + str(head.tooth_count) + " TEETH!")
			else:
				Log.add_log_message("IT TRIED TO PUSH TEETH INTO ITS HEAD, BUT ITS HEAD IS ALREADY FULL")
		Cell.TYPE.CHEST:
			if holding_key == true:
				holding_key = false
				ui.key_slot.visible = false
				ui.combat_viewport.drop_loot(true)
			else:
				Log.add_log_message("IT TRIED TO OPEN THE CHEST, BUT IT DOESN'T HAVE A KEY")
		Cell.TYPE.KEY:
			holding_key = true
			ui.key_slot.visible = true
			map.make_cell_empty(curr_cell)
			item_picked_up.emit()
			Log.add_log_message("IT PICKED UP A KEY TO THIS FLOOR'S CHEST")
	
#endregion

#region Arm Consumption and Manipulation
func remove_arm(a : Arm):
	arm_inventory.erase(a)
	arm_count -= 1
	Log.add_log_message("IT HAS LOST ONE OF ITS ARMS, IT NOW HAS " + str(arm_count) + " ARMS.")
	stat_change.emit()
	if Globals.verbose_console == true:
		debug_print_inventory()

# Apply conditions to hunger, tooth count, and health
func arm_bitten():
	#TODO: Randomize and check max and minimums
	var hunger_nourished : int = randi_range(arm_nurishment_min,arm_nurishment_max)
	var teeth_removed : int = randi_range(0,2)
	hunger = max(hunger- hunger_nourished,0)
	head.remove_teeth(teeth_removed)
	head.health = min(head.health + 1,head.max_health)
	if teeth_removed == 2:
		Log.add_log_message("IT TOOK A BITE FROM ONE OF ITS ARMS, NOURISHING " + str(hunger_nourished) + " HUNGER AND LOSING TWO TEETH.")
	elif teeth_removed == 1:
		Log.add_log_message("IT TOOK A BITE FROM ONE OF ITS ARMS, NOURISHING " + str(hunger_nourished) + " HUNGER AND LOSING ONE TOOTH.")
	else:
		Log.add_log_message("IT TOOK A BITE FROM ONE OF ITS ARMS, NOURISHING " + str(hunger_nourished) + " HUNGER.")
	stat_change.emit()
	set_hunger_state()

#endregion
	
#region Hunger Management
func tick_hunger():
	if hunger_state == HUNGER_LEVEL.DEAD:
		death_steps += 1
		if death_steps >= HUNGER_DAMAGE_TICK:
			hunger_damage()
	else:
		hunger += 1
	hunger_ticked.emit()
	set_hunger_state()

func hunger_damage():
	head.health -= 1
	AudioBank.play_rand(speaker, AudioBank.BANK.H_HURT)
	Log.add_log_message("IT'S HEAD TOOK DAMAGE DUE TO ITS ADVANCED HUNGER.")
	death_steps = 0
	if head.health <= 0:
		if Globals.verbose_console == true:
			print("PLAYER HAS DIED")
		#Log.add_log_message("IT HAS PERISHED.")
		#TODO: Stop all player input, pause, then transition to death scene
		#SceneTransition.testing_level()
		ui.combat_viewport.check_player_death()

func set_hunger_state():
	var before_state : HUNGER_LEVEL = hunger_state
	if hunger >= HUNGER_LEVEL.DEAD:
		hunger_state = HUNGER_LEVEL.DEAD
		attack_debuff = 0.4
	elif hunger >= HUNGER_LEVEL.STARVING:
		hunger_state = HUNGER_LEVEL.STARVING
		attack_debuff = 0.6
	elif hunger >= HUNGER_LEVEL.HUNGRY:
		hunger_state = HUNGER_LEVEL.HUNGRY
		attack_debuff = 0.8
	elif hunger >= HUNGER_LEVEL.SATISFIED:
		hunger_state = HUNGER_LEVEL.SATISFIED
		attack_debuff = 1.0
	var after_state : HUNGER_LEVEL = hunger_state
	if(before_state != after_state):
		if Globals.verbose_console == true:
			print("STATE SWITCH")
		AudioBank.play_rand(speaker, AudioBank.BANK.H_STATE)
		match hunger_state:
			HUNGER_LEVEL.SATISFIED:
				hunger_satisfied.emit()
				Log.add_log_message("ITS HUNGER IS NOW SATISFIED.")
			HUNGER_LEVEL.HUNGRY:
				hunger_hungry.emit()
				Log.add_log_message("IT IS NOW HUNGRY.")
			HUNGER_LEVEL.STARVING:
				hunger_starving.emit()
				death_steps = 0
				Log.add_log_message("IT IS NOW STARVING.")
			HUNGER_LEVEL.DEAD:
				hunger_dead.emit()
				Log.add_log_message("IT IS NOW DYING OF HUNGER.")
		stat_change.emit()

#endregion
