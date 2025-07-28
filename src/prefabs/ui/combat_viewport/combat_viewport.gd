extends MarginContainer

@export var root_ui : CanvasLayer
var player : Node
var map : Node
var opponent : Enemy 


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
@export var arm_container : HBoxContainer
var attacking_arm_object_scene : PackedScene = preload("uid://dljmxwj6vs50b")
# What arm is currently selected to attack with.
var attacking_arm : Arm

@export_category("TEMP ENEMY STATS")
@export var temp_e_health : Label
@export var temp_e_damage : Label

enum TURN {PLAYER,ENEMY}
var curr_turn : TURN = TURN.PLAYER
func _ready():
	visible = false
	player = root_ui.player
	map = root_ui.map


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func begin_combat(e : Enemy, loc : Vector2i):
	Log.add_log_message("IT HAS ENTERED COMBAT")
	visible = true
	att_die_roller.visible = false
	print("COMBAT BEGAN WITH ")
	e.debug_print()
	print("AT ", loc)
	opponent = e
	refresh_temp_labels()
	if e.anim != null:
		enemy_anim.sprite_frames = e.anim
	
func refresh_temp_labels():
	temp_e_health.text = "HEALTH: " + str(opponent.curr_health) + "/" + str(opponent.total_health)
	temp_e_damage.text = "DAMAGE: " + str(opponent.damage)
	pass

#region Combat Loop
func _on_attack_pressed():
	# Hide dialog box and buttons
	change_attack_run_vis(false)
	## Step 1: Let the player choose which arm they want to attack with
	# Gather and display the player's currently equipped arms
	refresh_arm_selections()
	change_arm_select_vis(true)

func refresh_arm_selections():
	#TODO: Call this function when an arm is fully eaten
	# Clear out all children, if any
	for child in arm_container.get_children():
		child.call_deferred("queue_free")
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
	## TODO: Eventually, rolls considerably under the DC will hurt the arm, for now, it just misses
	# Switch from viewing the arm selection screen, to the die roll screen and bring back the dialog box
	change_arm_select_vis(false)
	change_att_die_roller_vis(true)
	
	#TODO: Adjust bounds depending on arm conditions etc.
	att_die_roller.set_die(1,20,opponent.difficulty_class)
	#TODO: SET LABEL TO SHOW DIFFICULTY CLASS


func _on_attacking_die_roller_roll_results_ready(passed, number_rolled):
	print("DIE RESULTS READY")
	if passed == true:
		# Deal damage according to arm's strength
		opponent.curr_health -= attacking_arm.strength
		#TODO: Check for death
		refresh_temp_labels()
	else:
		#TODO: Apply damage to condition, update inventory menu, update arm selection screen
		pass
	#TODO: Could set a timer, and then show enemy's attack
	curr_turn = TURN.ENEMY



#endregion
#region Group Visibility Switching Functions
func change_attack_run_vis(new_vis : bool):
	dialog_box.visible = new_vis
	button_container.visible = new_vis
func change_arm_select_vis(new_vis : bool):
	arm_container.visible = new_vis
func change_att_die_roller_vis(new_vis : bool):
	dialog_box.visible = new_vis
	att_die_roller.visible = new_vis
#endregion
