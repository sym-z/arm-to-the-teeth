extends MarginContainer

@export var root_ui : CanvasLayer
var player : Node
var map : Node
var opponent : Enemy 
var combat_location : Vector2i
var player_dead : bool = false
var enemy_dead : bool = false


@export_category("Main Dialog Box")
@export var dialog_box : MarginContainer
@export_category("Dialog Box Button Choices")
@export var button_container : HBoxContainer
@export var attack_button : Button
@export var run_button : Button

@export_category("Dialog Box Die Rollers")
@export var att_die_roller : AnimatedSprite2D

@export_category("Animations")
@export var player_anim : AnimatedSprite2D
@export var enemy_anim : AnimatedSprite2D

@export_category("Attacking Arm Selection")
@export var arm_selection_window : MarginContainer
@export var arm_container : HBoxContainer
var attacking_arm_object_scene : PackedScene = preload("uid://dljmxwj6vs50b")
var attacking_head_object_scene : PackedScene = preload("uid://n07t7fqqy66w")
# What arm is currently selected to attack with.
var attacking_arm : Arm
# Flag set when attacking with head to give proper damage and consequences on roll
var attacking_with_head : bool

@export_category("Player Damage Selection")
@export var player_damage_selection_window : MarginContainer
@export var damage_limb_container : HBoxContainer
var damagable_limb_scene : PackedScene = preload("uid://c20d3pqcgllt8")

@export_category("Run Direction Selection")
@export var run_direction_selection_window : MarginContainer
@export var up_button : TextureButton
@export var down_button : TextureButton
@export var left_button : TextureButton
@export var right_button : TextureButton


@export_category("TEMP ENEMY STATS")
@export var temp_e_health : Label
@export var temp_e_damage : Label

enum TURN {PLAYER,ENEMY}
var curr_turn : TURN = TURN.PLAYER

var pause_time : float = 2.5
func _ready():
	visible = false
	player = root_ui.player
	map = root_ui.map


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func begin_combat(e : Enemy, loc : Vector2i):
	if Globals.verbose_console == true:
		print("COMBAT BEGAN WITH ")
		e.debug_print()
		print("AT ", loc)
	Log.add_log_message("IT HAS ENTERED COMBAT")
	visible = true
	enemy_dead = false
	show_player_turn_start()
	opponent = e
	combat_location = loc
	refresh_temp_labels()
	if e.anim != null:
		enemy_anim.sprite_frames = e.anim
	
func refresh_temp_labels():
	temp_e_health.text = "HEALTH: " + str(opponent.curr_health) + "/" + str(opponent.total_health)
	temp_e_damage.text = "DAMAGE: " + str(opponent.damage)
	pass

#region Combat Loop
	#region Player's Turn
		#region Run Option
func _on_run_pressed():
	# Show window
	change_run_direction_selection_vis(true)
	# Gather the directions that the player could run in. There is at least one guaranteed direction the player can run in.
	var forward_cell = map.get_forward_cell(player.position, player.facing)
	# Backward loc isn't *always* going to be a valid choice, because a player could back into an enemy.
	var backward_cell = map.get_backward_cell(player.position, player.facing)
	var left_cell = map.get_left_cell(player.position, player.facing)
	var right_cell = map.get_right_cell(player.position, player.facing)
	var possible_directions = [forward_cell,backward_cell,left_cell,right_cell]
	for d in possible_directions:
		if d != null:
			if Globals.verbose_console == true:
				print("PLAYER CAN RUN TO ", d.position)
			pass
	# The cells that exist need to be verified as a possible route of transportation
	if forward_cell != null and forward_cell.dir_to_wall(Globals.get_opposite_direction(player.facing))== false:
		up_button.visible = true
	if backward_cell != null and backward_cell.dir_to_wall(player.facing) == false:
		down_button.visible = true
	if left_cell != null and left_cell.dir_to_wall(Globals.right_of(player.facing)) == false:
		left_button.visible = true
	if right_cell != null and right_cell.dir_to_wall(Globals.left_of(player.facing)) == false:
		right_button.visible = true
func up_button_chosen():
	if Globals.verbose_console:
		print("PLAYER CHOSE TO RUN FORWARD")
	var forward_cell = map.get_forward_cell(player.position, player.facing)
	# Apply damage
	runaway_damage()
	if player_dead == false:
		visible = false
		Log.add_log_message("IT FLED AND RAN FORWARD")
		player.move()
		player.in_combat = false
		pass
	pass
func down_button_chosen():
	if Globals.verbose_console:
		print("PLAYER CHOSE TO RUN BACKWARD")
	var backward_cell = map.get_backward_cell(player.position, player.facing)
	# Apply damage
	runaway_damage()
	if player_dead == false:
		visible = false
		Log.add_log_message("IT FLED AND RAN BACKWARD")
		player.move(-1)
		player.in_combat = false
		pass
	pass
func left_button_chosen():
	if Globals.verbose_console:
		print("PLAYER CHOSE TO RUN TO THE LEFT")
	var left_cell = map.get_left_cell(player.position, player.facing)
	# Apply damage
	runaway_damage()
	if player_dead == false:
		visible = false
		Log.add_log_message("IT FLED AND RAN TO THE LEFT")
		player.force_turn_left()
		player.move()
		player.force_turn_right()
		player.in_combat = false
		pass
	pass
func right_button_chosen():
	if Globals.verbose_console:
		print("PLAYER CHOSE TO RUN TO THE RIGHT")
	var right_cell = map.get_right_cell(player.position, player.facing)
	# Apply damage
	runaway_damage()
	if player_dead == false:
		visible = false
		Log.add_log_message("IT FLED AND RAN TO THE RIGHT")
		player.force_turn_right()
		player.move()
		player.force_turn_left()
		player.in_combat = false
		pass
	pass
# Have the enemy roll to see if they will hit the player, where, and for how much damage. Sets player_dead on death.
func runaway_damage():
	if Globals.verbose_console:
		print("APPLYING RUNAWAY DAMAGE")
	# Disable inventory management
	root_ui.inventory_button.disabled = true
	# Choose where to hit player, may default to head
	# Temporarily always chooses head
	# Roll using player's head health as DC / head health + teeth
	var enemy_roll : int = randi_range(0,20)
	if enemy_roll > player.head.health:
		# Apply damage
		player.head.health -= opponent.damage
		Log.add_log_message("IT TOOK " + str(opponent.damage) + " DAMAGE WHILE FLEEING!")
	else:
		Log.add_log_message("IT MANAGED TO FLEE AND TAKE NO DAMAGE")
	# Check for death or arm destruction
	check_player_death()
	# Enable inventory management
	root_ui.inventory_button.disabled = false
	pass
		#endregion
		#region Attack Option
func _on_attack_pressed():
	# Hide dialog box and buttons
	change_attack_run_vis(false)
	## Step 1: Let the player choose which arm they want to attack with
	# Gather and display the player's currently equipped arms
	refresh_arm_selections()
	change_arm_select_vis(true)
# Refresh arm (and head) selections for combat
func refresh_arm_selections():
	#TODO: Call this function when an arm is fully eaten
	# Clear out all children, if any
	for child in arm_container.get_children():
		child.call_deferred("queue_free")
	# Add head of player first
	var new_head_obj = attacking_head_object_scene.instantiate()
	new_head_obj.input_head(player.head)
	new_head_obj.connect("attacking_head_selected", attacking_head_selected)
	arm_container.add_child(new_head_obj)
	# Refill with current arm inventory state
	for arm in player.arm_inventory:
		# Not necessary now, but will be helpful later.
		if arm.equipped == true:
			var new_arm_obj = attacking_arm_object_scene.instantiate()
			new_arm_obj.input_arm(arm)
			new_arm_obj.connect("attacking_arm_selected", attacking_arm_selected)
			arm_container.add_child(new_arm_obj)

func attacking_arm_selected(a : Arm):
	## Step 2: Using the stats of the arm, let the player roll a die to attempt to hit the monster
	attacking_arm = a
	attacking_with_head = false
	## TODO: Eventually, rolls considerably under the DC will hurt the arm, for now, it just misses
	# Switch from viewing the arm selection screen, to the die roll screen and bring back the dialog box
	change_arm_select_vis(false)
	change_att_die_roller_vis(true)
	# Disable the ability to check and modify inventory during a roll
	root_ui.inventory_button.disabled = true
	Log.add_log_message("ARM SELECTION MADE, ARM MANAGEMENT TEMPORARILY DISABLED")
	# Reset Die Roller
	att_die_roller.reset_die()
	#TODO: Adjust bounds depending on arm conditions etc.
	if Globals.debug_combat == false:
		att_die_roller.set_die(1,20,opponent.difficulty_class)
	else:
		# Impossible roll to test arm getting hurt
		att_die_roller.set_die(1,20,1)
		#att_die_roller.set_die(1,20,opponent.difficulty_class)
	#TODO: SET LABEL TO SHOW DIFFICULTY CLASS
func attacking_head_selected(h : Head):
	## Step 2b: Using the stats of the head, let the player roll a die to attempt to hit the monster
	#attacking_arm = a
	attacking_with_head = true
	## TODO: Eventually, rolls considerably under the DC will hurt the head or kill the player, for now, it just misses
	# Switch from viewing the arm selection screen, to the die roll screen and bring back the dialog box
	change_arm_select_vis(false)
	change_att_die_roller_vis(true)
	# Disable the ability to check and modify inventory during a roll
	root_ui.inventory_button.disabled = true
	Log.add_log_message("IT CHOSE TO ATTACK WITH ITS HEAD, ARM MANAGEMENT TEMPORARILY DISABLED")
	att_die_roller.reset_die()
	#TODO: Adjust bounds depending on head health etc.
	if Globals.debug_combat == false:
		att_die_roller.set_die(1,20,opponent.difficulty_class)
	else:
		#att_die_roller.set_die(1,20,20)
		att_die_roller.set_die(1,20,opponent.difficulty_class)
	#TODO: SET LABEL TO SHOW DIFFICULTY CLASS

func _on_attacking_die_roller_roll_results_ready(passed, number_rolled, dc):
	#TODO: MAKE THIS WORK IF HEAD IS SELECTED
	if Globals.verbose_console == true:
		print("DIE RESULTS READY")
	# Activate the ability for the player to check their inventory now that the roll has finished
	root_ui.inventory_button.disabled = false
	if attacking_with_head == false:
		## Player Hit
		if passed == true:
			# Deal damage according to arm's strength
			opponent.curr_health -= attacking_arm.strength
			#TODO: Maybe bonus damage for high rolls?
			Log.add_log_message("IT DEALT " + str(attacking_arm.strength) + " DAMAGE.")
			refresh_temp_labels()
			# Check for enemy death
			check_enemy_death()
		## Player Miss
		else:
			#TODO: Apply damage to condition, update inventory menu, update arm selection screen
			# Apply damage to arm's condition equal to how far the roll was under half the dc
				# Ex: Roll = 2, DC = 10, damage_to_apply = floor(DC/2)-Roll = floor(10/2)-2 = 5-2 = 3 
			if number_rolled < floor(dc/2):
				var damage_to_apply : int = floor(dc/2) - number_rolled
				attacking_arm.condition -= damage_to_apply
				# Check if arm was destroyed
				#TODO: WHEN ARMS ARE IN UI ADJUST FRAMING BASED ON CONDITION
				if attacking_arm.condition <= 0:
					Log.add_log_message("IT MISSED ITS ATTACK AND ITS ARM WAS DAMAGED BEYOND USE.")
					root_ui.arm_fully_eaten(attacking_arm)
				else:
					Log.add_log_message("IT MISSED ITS ATTACK GOT HURT, ARM LOST " + str(damage_to_apply) + " CONDITION.")
			else:
				Log.add_log_message("IT MISSED ITS ATTACK.")
	else:
		# Head Attack
		## Player hit
		if passed == true:
			# Deal damage according to head's strength
			opponent.curr_health -= player.head.strength
			#TODO: Possible bonus damage for high rolls/teeth count?
			Log.add_log_message("IT BIT FURIOUSLY AND DEALT " + str(player.head.strength) + " DAMAGE.")
			#TODO: Deduct teeth, perhaps with a roll, would need to refresh root_ui's labels
			refresh_temp_labels()
			# Check for enemy death
			check_enemy_death()
		else:
			## Player missed
			# Head loses health, and teeth are lost. Possibly roll for teeth lost.
			#TODO: Have low rolls factor into more health and teeth lost
			player.head.health -= 1
			# Refresh root_ui's labels
			root_ui.refresh_temp_labels()
			# Check for player death.
			check_player_death()
			Log.add_log_message("IT MISSED ITS BITE, HURTING ITS HEAD IN THE PROCESS.")
	curr_turn = TURN.ENEMY
	#TODO: Later this could be attached to the player's attack animation as well
	create_timer(pause_time, enemy_attack_roll)
		#endregion
	#endregion
	#region Enemy's Turn
# Enemy rolls to attempt to attack player
func enemy_attack_roll():
	if enemy_dead == false:
		# Hide player's die roll screen
		change_att_die_roller_vis(false)
		# Player's DC is dependent on head health.
		var enemy_roll = randi_range(1,20)
		if Globals.debug_combat == true:
			enemy_roll = 20 
			pass
		if enemy_roll < player.head.health:
			# Enemy Miss
			Log.add_log_message("THE ENEMY WENT FOR AN ATTACK, BUT MISSED!")
			#TODO: BACK TO ATTACK/RUN CHOICE AFTER TIMER
			create_timer(pause_time, show_player_turn_start)
		else:
			# Enemy Hit
			#TODO: Possibly extra damage for high roll?
			Log.add_log_message("THE ENEMY'S ATTACK HITS!")
			#TODO: Later this could be attached to the enemy's attack animation as well
			create_timer(pause_time, player_damage_selection)

## Player decides what body part receives damage
func player_damage_selection():
	# Reveal body part selection screen
	if Globals.verbose_console == true:
		print("PLAYER DAMAGE SELECTION TIME")
	change_player_damage_selection_vis(true)
	# Disable the ability to check and modify inventory during damage selection
	root_ui.inventory_button.disabled = true
	## Limb container should clear out all children, if any, then build from the current state of the player
	for child in damage_limb_container.get_children():
		child.call_deferred("queue_free")
	# Add player head
	var new_head_limb = damagable_limb_scene.instantiate()
	new_head_limb.input_head(player.head)
	new_head_limb.connect("damage_head", damage_head)
	damage_limb_container.add_child(new_head_limb)
	# Add player's equipped arms
	for arm in player.arm_inventory:
		if arm.equipped == true:
			var new_arm_limb = damagable_limb_scene.instantiate()
			new_arm_limb.input_arm(arm)
			new_arm_limb.connect("damage_arm", damage_arm)
			damage_limb_container.add_child(new_arm_limb)

func damage_head(h: Head):
	if Globals.verbose_console:
		print("DAMAGING HEAD")
	#TODO: Factor in teeth lost, critical hits
	if Globals.debug_combat == true:
		h.health -= h.health
	else:
		h.health -= opponent.damage
	# Update status in UI of head
	root_ui.refresh_temp_labels()
	# Re-Enable inventory use after damage is applied
	root_ui.inventory_button.disabled = false
	check_player_death()
	# Go to attack/run right after damage application
	if player_dead == false:
		#create_timer(3.5, show_player_turn_start)
		show_player_turn_start()
	
func damage_arm(a: Arm):
	if Globals.verbose_console:
		print("DAMAGING ARM")
	a.condition -= opponent.damage
	if a.condition <= 0:
		root_ui.arm_fully_eaten(a)
	# Re-Enable inventory use after damage is applied
	root_ui.inventory_button.disabled = false
	# Go to attack/run right after damage application
	show_player_turn_start()
	#endregion
	#region Combat Ending State
func check_player_death():
	if player.head.health <= 0:
		if Globals.verbose_console == true:
			print("PLAYER HAS DIED")
		player_dead = true
		Log.add_log_message("IT HAS PERISHED.")
		#TODO: Stop all player input, pause, then transition to death scene
		SceneTransition.testing_level()

func check_enemy_death():
	if opponent.curr_health <= 0:
		Log.add_log_message("IT HAS VANQUISHED THE ENEMY.")
		# Set flag
		enemy_dead = true
		# Hide combat viewport
		visible = false
		# Get cell that combat is taking place in
		var map_cell : Cell = map.world_map[combat_location]
		# Remove enemy from map's atlas at combat_location
		map.enemy_atlas.erase(combat_location)
		# Make the cell empty at that location
		map.make_cell_empty(map_cell)
		# This signal tells the viewport to refresh, tells the UI that the cell is empty, and tells the minimap to get rid of the icon at this location.
		player.item_picked_up.emit()
		# Allow the player to move
		player.in_combat = false
		if Globals.verbose_console == true:
			print("ENEMY KILLED")
			map.print_enemy_atlas()
			print("THERE ARE NOW ", map.enemy_atlas.keys().size(), " ENEMIES LEFT.")
	#endregion
#endregion
#region Group Visibility Switching Functions
func change_attack_run_vis(new_vis : bool):
	dialog_box.visible = new_vis
	button_container.visible = new_vis
func change_arm_select_vis(new_vis : bool):
	arm_selection_window.visible = new_vis
func change_att_die_roller_vis(new_vis : bool):
	dialog_box.visible = new_vis
	att_die_roller.visible = new_vis
func change_player_damage_selection_vis(new_vis : bool):
	player_damage_selection_window.visible = new_vis
func change_run_direction_selection_vis(new_vis : bool):
	run_direction_selection_window.visible = new_vis
	change_attack_run_vis(false)
	# Start with all buttons invisible
	up_button.visible = false
	down_button.visible = false
	left_button.visible = false
	right_button.visible = false
func show_player_turn_start():
	change_arm_select_vis(false)
	change_att_die_roller_vis(false)
	change_player_damage_selection_vis(false)
	change_run_direction_selection_vis(false)
	change_attack_run_vis(true)
#endregion


#region Tools
## Create a timer that after "duration" seconds calls "callback" and destroys itself
func create_timer(duration : float, callback: Callable):
	if Globals.debug_combat == true:
		duration = 0.1
	var t : Timer = Timer.new()
	t.connect("timeout", callback)
	t.connect("timeout", t.queue_free)
	t.one_shot = true
	t.wait_time = duration
	add_child(t)
	t.start()
#endregion
