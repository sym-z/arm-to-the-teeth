extends CanvasLayer

#region Initializations and Export Variables
@export var player : Node 
@export var map : Node

@export_category("Context Menu Buttons")
@export var pickup_button : Button
@export var inventory_button : Button
@export var options_button : Button
@export var quit_button : Button

@export_category("Options Menu")
@export var options_container : MarginContainer
@export var curr_speed_label : Label
@export var slow_speed_button : Button
@export var slow_battle_speed : float = 2.5
@export var med_speed_button : Button
@export var med_battle_speed : float = 1.5
@export var fast_speed_button : Button
@export var fast_battle_speed : float = 0.5
@export var options_back_button : Button


@export_category("Temporary Labels")
@export var tooth_label : Label
@export var arm_label : Label
@export var head_label : Label
@export var hunger_label : Label


# For adding arms to the inventory
var item_to_pick : Cell.TYPE = Cell.TYPE.EMPTY
@export_category("Inventory")
@export var inventory_container : MarginContainer
@export var item_container : VBoxContainer
@export var inv_back_button : Button
var arm_item_scene : PackedScene = preload("uid://cs01wd2aki26b")

@export_category("Log")
@export var log_line_label : RichTextLabel 
## What holds the logs
@export var full_log_container : VBoxContainer
## What holds the whole window
@export var full_log_window_container : MarginContainer
## Scroller
@export var full_log_scroller : ScrollContainer
## Back button for full window
@export var full_log_back_button : Button
var full_log_label_scene : PackedScene = preload("uid://dp85jko1wcurv")

@export_category("Viewport Header")
@export var viewport_header_label : RichTextLabel

@export_category("Mini Map")
@export var mini_map : Node2D

@export_category("Combat Viewport")
@export var combat_viewport : MarginContainer

@export_category("Stat Showcase")
@export var head_anim : AnimatedSprite2D
@export var stomach_anim : AnimatedSprite2D
@export var equipped_arm_anim_1 : AnimatedSprite2D
@export var equipped_arm_anim_2 : AnimatedSprite2D
@export var tooth_anim : AnimatedSprite2D

@export_category("Eye Transition")
@export var eye_anim : AnimatedSprite2D

@export_category("Gate Transition")
@export var gate_anim : AnimatedSprite2D

@export_category("Gate Notification")
@export var gate_notif_container : MarginContainer

@export_category("Audio")
@export var speaker : AudioStreamPlayer
#endregion
func _ready():
	Log.connect("new_log", update_log_line)
	Log.connect("new_log", update_full_log)
	# If the player died, allow them to still access their logs from the previous run
	if Log.log_messages.size() > 0:
		post_death_log_transfer()
	# Initialize viewport header label
	viewport_header_label.text = "FLOOR: " + str(Globals.curr_floor)
	# Adds default log line text as first log
	Log.add_log_message(log_line_label.text)
	gate_notif_container.visible = false

# Work should start only when the map is done filling.
func _on_map_map_filled():
	change_inventory_visibility(false)
	change_full_log_window_visibility(false)
	pickup_button.disabled = true
	refresh_temp_labels()
	# Run initial setup if this is the beginning of play.
	if Globals.curr_floor == 0:
		initial_setup()

# What should only run at the after the very first floor generates.
func initial_setup():
	# Add initial arms to inventory
	for i in range(player.arm_inventory.size()):
		add_arm_to_inventory(player.arm_inventory[i], i+1)
	player.connect("stat_change", refresh_stat_showcase)
	player.connect("item_picked_up", refresh_stat_showcase)
	player.connect("item_partial_pickup", refresh_stat_showcase)
	refresh_stat_showcase()
	
	eye_anim.frame = eye_anim.sprite_frames.get_frame_count("default") - 1
	eye_anim.play_backwards("default")
	
	gate_anim.connect("animation_finished", hide_gate_anim)
	

#region Mini Map
func _on_mini_map_mini_map_ready():
	mini_map.create_visualization()
#endregion

func _input(event):
	if event.is_action_pressed("open_inventory"):
		if inventory_button.disabled == false:
			inventory_button.pressed.emit()
	elif event.is_action_pressed("pick_up"):
		if pickup_button.disabled == false:
			pickup_button.pressed.emit()
			
#region Viewport Header
func _on_map_level_clear():
	viewport_header_label.text = "FLOOR: " + str(Globals.curr_floor)
#endregion

func refresh_temp_labels():
	tooth_label.text = "TOOTH COUNT: " + str(player.head.tooth_count)
	arm_label.text = "ARM COUNT: " + str(player.arm_count)
	head_label.text = "HEAD HEALTH: (" + str(player.head.health) + "/" + str(player.head.max_health) + ")"
	hunger_label.text = "HUNGER LEVEL: " + str(player.hunger)

func _on_player_hunger_ticked():
	refresh_temp_labels()

#region Item Pickup and Detection
# Preps the UI to pick up what is at the feet of the player
func _on_player_item_detected(item, loc):
	match item:
		Cell.TYPE.EMPTY:
			pickup_button.disabled = true
			item_to_pick = Cell.TYPE.EMPTY
		Cell.TYPE.SPAWN:
			pickup_button.disabled = true
			item_to_pick = Cell.TYPE.SPAWN
		Cell.TYPE.EXIT:
			pickup_button.disabled = true
			item_to_pick = Cell.TYPE.EXIT
			gate_notify()
		Cell.TYPE.ARM:
			pickup_button.disabled = false
			item_to_pick = Cell.TYPE.ARM
		Cell.TYPE.TOOTH:
			pickup_button.disabled = false
			item_to_pick = Cell.TYPE.TOOTH
		Cell.TYPE.ENEMY:
			pickup_button.disabled = true
			item_to_pick = Cell.TYPE.ENEMY
	if pickup_button.disabled == false:
		pickup_button.start_blink()
	elif pickup_button.curr_state == pickup_button.STATE.BLINK:
		pickup_button.end_blink()

func gate_notify():
	player.disable_movement = true
	gate_notif_container.visible = true
func gate_accept():
	gate_anim.visible = true
	gate_anim.play()
	map.new_level()
	gate_notif_container.visible = false
	player.disable_movement = false
func gate_reject():
	player.disable_movement = false
	gate_notif_container.visible = false



func hide_gate_anim():
	gate_anim.visible = false

# When the player picks up what is at their feet, set the UI to the correct state.
func _on_player_item_picked_up():
	pickup_button.disabled = true
	item_to_pick = Cell.TYPE.EMPTY
	refresh_temp_labels()

func _on_player_item_partial_pickup():
	refresh_temp_labels()
	
	
func add_arm_to_inventory(a : Arm, number : int):
	var new_arm_item = arm_item_scene.instantiate()
	new_arm_item.set_text_to_arm(a, number)
	new_arm_item.connect("eat_pressed", arm_eaten)
	new_arm_item.connect("arm_fully_eaten", arm_fully_eaten)
	item_container.add_child(new_arm_item)
#endregion
#region Context Menu Button Presses
func _on_pick_up_pressed():
	player.pick_up(item_to_pick)
func _on_inventory_pressed():
	change_inventory_visibility(not inventory_container.visible)
	# Refresh inventory when the window is pulled up, rather than relying on other parts of the code to update it
	if inventory_container.visible == true:
		# Clear out child nodes in the item container
		for child in item_container.get_children():
			child.call_deferred("queue_free")
		# Refill container with arms
		for i in player.arm_inventory.size():
			add_arm_to_inventory(player.arm_inventory[i], i+1)
			pass
		pass
func _on_quit_pressed():
	get_tree().quit()

func _on_options_pressed():
	options_container.visible = !options_container.visible
	pass
#endregion
#region Options Window
func set_slow_battle_speed():
	combat_viewport.pause_time = slow_battle_speed
	curr_speed_label.text = "CURRENT SPEED: SLOW"
func set_med_battle_speed():
	combat_viewport.pause_time = med_battle_speed
	curr_speed_label.text = "CURRENT SPEED: MEDIUM"
func set_fast_battle_speed():
	combat_viewport.pause_time = fast_battle_speed
	curr_speed_label.text = "CURRENT SPEED: FAST"
#endregion
#region Inventory Window
func change_inventory_visibility(new_vis : bool):
	inventory_container.visible = new_vis
	inv_back_button.visible = new_vis
	# Hide log window
	if new_vis == true:
		change_full_log_window_visibility(false)

func arm_eaten(arm_object : Arm):
	# Check tooth count to see if it is possible
	if player.head.tooth_count > 0:
		arm_object.condition = max(arm_object.condition - randi_range(1,3), 0)
		# Adjust hunger, health, arm count etc.
		player.arm_bitten()
		AudioBank.play_rand(speaker,AudioBank.BANK.ARM_EAT)
		if player.in_combat == true:
			combat_viewport.refresh_arm_selections()
		refresh_temp_labels()
	else:
		Log.add_log_message("IT TRIED TO TAKE A BITE OF ITS ARM, BUT IT HAD NO TEETH TO DO SO.")

func arm_fully_eaten(arm_object : Arm):
	player.remove_arm(arm_object)
	if player.in_combat == true:
		combat_viewport.refresh_arm_selections()
	refresh_temp_labels()
	#TODO: UPDATE ATT ARM SELECTION 

func _on_back_button_pressed():
	change_inventory_visibility(false)
#endregion

#region Log Window
func change_full_log_window_visibility(new_vis : bool):
	full_log_window_container.visible = new_vis
	full_log_back_button.visible = new_vis
	# Hide inventory
	if new_vis == true:
		change_inventory_visibility(false)
func update_log_line():
	log_line_label.text = Log.log_messages.back()
func update_full_log():
	var new_log_msg = full_log_label_scene.instantiate()
	new_log_msg.text = Log.log_messages.back()
	full_log_container.add_child(new_log_msg)
	full_log_container.move_child(new_log_msg,0)
func _on_log_line_window_gui_input(event):
	if event is InputEventMouseButton and event.button_index ==1 and event.pressed == true:
		change_full_log_window_visibility(not full_log_window_container.visible)
func _on_full_window_back_button_pressed():
	change_full_log_window_visibility(false)
func post_death_log_transfer():
	for msg in Log.log_messages:
		var new_log_msg = full_log_label_scene.instantiate()
		new_log_msg.text = msg
		full_log_container.add_child(new_log_msg)
		full_log_container.move_child(new_log_msg,0)
#endregion

#region Combat Handling
func _on_player_combat_started(enemy, loc):
	combat_viewport.begin_combat(enemy,loc)
#endregion

#region Stat Showcase
func refresh_stat_showcase():
	refresh_head_stat()
	refresh_stomach_stat()
	refresh_arm_stat()
	refresh_tooth_stat()

func refresh_tooth_stat():
	if player.head.tooth_count >= 0 and player.head.tooth_count <= player.head.TOOTH_MAX:
		tooth_anim.frame = player.head.tooth_count
	else:
		push_error("In refresh_stat_showcase in ui.gd, tooth count set to either negative or above possible value")
		
func refresh_arm_stat():
	# Index through inventory, and reveal an arm for each arm that is equipped. 
	var equipped_count : int = 0
	var equipped_arms : Array[Arm] = []
	for arm in player.arm_inventory:
		if arm.equipped == true:
			equipped_count += 1
			equipped_arms.append(arm)
	match equipped_count:
		1:
			equipped_arm_anim_1.visible = true
			equipped_arm_anim_2.visible = false
			# Apply same strategy used in head stat showcase
			set_arm_frame(equipped_arms[0], equipped_arm_anim_1)
		2:
			equipped_arm_anim_1.visible = true
			equipped_arm_anim_2.visible = true
			set_arm_frame(equipped_arms[0], equipped_arm_anim_1)
			set_arm_frame(equipped_arms[1], equipped_arm_anim_2)
		_:
			equipped_arm_anim_1.visible = false
			equipped_arm_anim_2.visible = false
	if equipped_count > 2:
		push_error("Error in function refresh_stat_showcase in ui.gd, more than 2 arms are equipped when refreshing stat showcase.")

func set_arm_frame(a : Arm, anim : AnimatedSprite2D):
	var total_arm_frames = anim.sprite_frames.get_frame_count("default") - 1
	var condition : float = a.condition
	var max_condition : float = a.max_condition
	var condition_percent : float = condition / max_condition
	var frame_num = floor(total_arm_frames * condition_percent)
	anim.frame = total_arm_frames - frame_num
	
func refresh_stomach_stat():
	if player.hunger == 0:
		stomach_anim.frame = 0
	else:
		var total_stomach_frames = stomach_anim.sprite_frames.get_frame_count("default") - 1
		var hunger : float = player.hunger
		var max_hunger : float = player.HUNGER_LEVEL.DEAD
		var hunger_percent : float = hunger/max_hunger
		var frame_num = floor(total_stomach_frames * hunger_percent)
		stomach_anim.frame = frame_num

			
func refresh_head_stat():
	# Get frame size, zero-indexed
	var total_head_frames = head_anim.sprite_frames.get_frame_count("default") - 1
	# Calculate percentage of player health, using floats
	var health : float = player.head.health
	var max_hp : float = player.head.max_health
	var health_percent : float = health / max_hp
	# Apply this percentage to the total frames of the head animation
	var frame_num = floor(total_head_frames * health_percent)
	head_anim.frame = total_head_frames - frame_num
#endregion
