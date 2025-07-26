extends CanvasLayer

@export var player : Node 
@export var map : Node

@export_category("Context Menu Buttons")
@export var pickup_button : Button
@export var inventory_button : Button
@export var attack_button : Button
@export var run_button : Button
@export var options_button : Button
@export var quit_button : Button


@export_category("Temporary Labels")
@export var tooth_label : Label
@export var arm_label : Label
@export var head_label : Label
@export var hunger_label : Label

var item_to_pick : Cell.TYPE = Cell.TYPE.EMPTY

# For adding arms to the inventory
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
func _ready():
	Log.connect("new_log", update_log_line)
	Log.connect("new_log", update_full_log)
	pass # Replace with function body.

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

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func refresh_temp_labels():
	tooth_label.text = "TOOTH COUNT: " + str(player.tooth_count)
	arm_label.text = "ARM COUNT: " + str(player.arm_count)
	head_label.text = "HEAD HEALTH: " + str(player.head_health)
	hunger_label.text = "HUNGER LEVEL: " + str(player.hunger)

func _on_player_hunger_ticked():
	refresh_temp_labels()

#region Item Pickup and Detection
# Preps the UI to pick up what is at the feet of the player
func _on_player_item_detected(item, loc):
	match item:
		Cell.TYPE.EMPTY:
			pickup_button.disabled = true
			disable_combat_buttons()
			item_to_pick = Cell.TYPE.EMPTY
		Cell.TYPE.SPAWN:
			pickup_button.disabled = true
			disable_combat_buttons()
			item_to_pick = Cell.TYPE.SPAWN
		Cell.TYPE.EXIT:
			pickup_button.disabled = true
			disable_combat_buttons()
			item_to_pick = Cell.TYPE.EXIT
		Cell.TYPE.ARM:
			pickup_button.disabled = false
			disable_combat_buttons()
			item_to_pick = Cell.TYPE.ARM
		Cell.TYPE.TOOTH:
			pickup_button.disabled = false
			disable_combat_buttons()
			item_to_pick = Cell.TYPE.TOOTH
		Cell.TYPE.ENEMY:
			pickup_button.disabled = true
			enable_combat_buttons()
			item_to_pick = Cell.TYPE.ENEMY
			
# When the player picks up what is at their feet, set the UI to the correct state.
func _on_player_item_picked_up():
	pickup_button.disabled = true
	item_to_pick = Cell.TYPE.EMPTY
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
	if player.tooth_count > 0:
		arm_object.condition -= 1
		# Adjust hunger, health, arm count etc.
		player.arm_bitten()
		refresh_temp_labels()

func arm_fully_eaten(arm_object : Arm):
	player.remove_arm(arm_object)
	refresh_temp_labels()
	pass

func _on_back_button_pressed():
	change_inventory_visibility(false)
#endregion

#region Combat Buttons
func disable_combat_buttons():
	attack_button.disabled = true
	run_button.disabled = true
func enable_combat_buttons():
	attack_button.disabled = false
	run_button.disabled = false
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
	pass # Replace with function body.

func _on_full_window_back_button_pressed():
	change_full_log_window_visibility(false)
	pass # Replace with function body.
#endregion
