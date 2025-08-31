extends MarginContainer
@export var combat_viewport : MarginContainer
@export var finger_anims : Node2D
@export var blockable_wait_time: Timer
@export var blockable_duration : Timer

@export_category("Containers")
@export var left_container : MarginContainer
@export var head_container : MarginContainer
@export var right_container : MarginContainer
@export var tutorial_container : MarginContainer

@export_category("Buttons")
@export var left_button : TextureButton
@export var head_button : TextureButton
@export var right_button : TextureButton
@export var ready_button : Button
@export var tutorial_button : Button

@export_category("Panel Styleboxes")
@export var panel : PanelContainer
@export var default_box : StyleBoxFlat
@export var fail_box : StyleBoxFlat
@export var ready_box : StyleBoxFlat
@export var success_box : StyleBoxFlat
@export var block_box : StyleBoxFlat

var highlight_left : CompressedTexture2D = preload("uid://bk1434tm4rg5j")
var highlight_head : CompressedTexture2D = preload("uid://byb6swm1xbyb0")
var highlight_right : CompressedTexture2D = preload("uid://coddoaf01a0cg")

var highlight_left_hover : CompressedTexture2D = preload("uid://cs6d7r8xxbs5t")
var highlight_head_hover : CompressedTexture2D = preload("uid://ba4kehfjmxe63")
var highlight_right_hover : CompressedTexture2D = preload("uid://pmqf7w2y2r0w")

var default_left : CompressedTexture2D = preload("uid://b3am1sni15h2b")
var default_head : CompressedTexture2D = preload("uid://b7ntjjx5drk2q")
var default_right : CompressedTexture2D = preload("uid://badpw3mu3fsl1")

var hover_left : CompressedTexture2D = preload("uid://bpag8xjuarg1c")
var hover_head : CompressedTexture2D = preload("uid://4hluvw65gqu8")
var hover_right : CompressedTexture2D = preload("uid://cy0id8vi086ow")


var cutting_left : bool = false
var cutting_right : bool = false
var cutting_head : bool = false

var limb_array : Array[Variant] = []

# When this is true a block can be registered
var block_available : bool = false
var player_ready : bool = false
var block_success : bool = false
var punished : bool = false
# Called when the node enters the scene tree for the first time.
func _ready():
	pass
#region Player Input
func _input(event):
	if player_ready == true:
		if combat_viewport.player.in_combat == true:
			if event.is_action_pressed("turn_left"):
				_on_left_arrow_pressed()
				#if block_available == true and cutting_left == true:
					#block_attack()
				#else:
					##TODO: Punish
					#punish()
			elif event.is_action_pressed("move_forward"):
				_on_up_arrow_pressed()
				#if block_available == true and cutting_head == true:
					#block_attack()
				#else:
					##TODO: Punish
					#punish()
			elif event.is_action_pressed("turn_right"):
				_on_right_arrow_pressed()
				#if block_available == true and cutting_right == true:
					#block_attack()
				#else:
					##TODO: Punish
					#punish()
func _on_left_arrow_pressed():
	if block_available == true:
		if cutting_left == true:
			block_attack()
		else:
			punish(true)
	elif player_ready == false:
		Log.add_log_message("PRESS THE READY BUTTON BEFORE ATTEMPTING TO BLOCK.")
	else:
		punish()


func _on_up_arrow_pressed():
	if block_available == true:
		if cutting_head == true:
			block_attack()
		else:
			punish(true)
	elif player_ready == false:
		Log.add_log_message("PRESS THE READY BUTTON BEFORE ATTEMPTING TO BLOCK.")
	else:
		punish()

func _on_right_arrow_pressed():
	if block_available == true:
		if cutting_right == true:
			block_attack()
		else:
			punish(true)
	elif player_ready == false:
		Log.add_log_message("PRESS THE READY BUTTON BEFORE ATTEMPTING TO BLOCK.")
	else:
		punish()
#endregion
func begin_game():
	ready_button.disabled = false
	panel.add_theme_stylebox_override("panel", default_box)
	reset_button_textures()
	combat_viewport.change_wheel_roller_vis(false)
	visible = true
	ready_button.text = "READY?\nPRESS ME."
	Log.add_log_message("IT READIED ITSELF FOR THE UPCOMING ATTACK.")
	# TODO: Adjust this for difficulty based on floor level and hunger
	blockable_duration.wait_time = 1.8
	
	# Identify number of equipped limbs
	limb_array.clear()
	limb_array.append(combat_viewport.player.head)
	for arm in combat_viewport.player.arm_inventory:
		if arm.equipped == true:
			limb_array.append(arm)
	# Set animation
	finger_anims.set_finger_number(limb_array.size())
	print("NUM LIMBS: ", limb_array.size)
	finger_anims.curr_anim.play()
	
	if limb_array.size() > 3:
		push_error("Incorrect number of limbs equipped in begin_game() function in finger_react.gd")
		return
	gui_setup()

## Only show relevent gui for current limb setup
func gui_setup():
	match limb_array.size():
		1:
			left_container.visible = false
			head_container.visible = true
			right_container.visible = false
		2:
			left_container.visible = true
			head_container.visible = true
			right_container.visible = false
		3:
			left_container.visible = true
			head_container.visible = true
			right_container.visible = true
	
func reset_button_textures():
	left_button.texture_normal = default_left
	head_button.texture_normal = default_head
	right_button.texture_normal = default_right
	left_button.texture_hover = hover_left
	head_button.texture_hover = hover_head
	right_button.texture_hover = hover_right

## Starts a timer when ready that on completion will begin the blockable phase of the minigame
func rand_wait():
	player_ready = true
	panel.add_theme_stylebox_override("panel", ready_box)
	ready_button.text = "GOOD LUCK."
	var rand_time : float = randf_range(1.0,3.5)
	blockable_wait_time.wait_time = rand_time
	blockable_wait_time.start()
	# Calculate which limb will be hit
	var rand_choice = randi_range(0,limb_array.size()-1)
	match rand_choice:
		0:
			cutting_left = false
			cutting_head = true
			cutting_right = false
		1:
			cutting_left = true
			cutting_head = false
			cutting_right = false
		2:
			cutting_left = false
			cutting_head = false
			cutting_right = true

	
## Opens the scissors and accepts a block input for a moment
func cut_finger():
	print("cut_finger")
	finger_anims.curr_anim.pause()
	panel.add_theme_stylebox_override("panel", block_box)
	if cutting_head == true:
		# Head hit play cut_2
		finger_anims.curr_anim.animation = "cut_2"
		ready_button.text = "PRESS UP / W"
		head_button.texture_normal = highlight_head
		head_button.texture_hover = highlight_head_hover
	elif cutting_left == true:
		# Left arm hit, cut_1
		finger_anims.curr_anim.animation = "cut_1"
		ready_button.text = "PRESS LEFT / A"
		left_button.texture_normal = highlight_left
		left_button.texture_hover = highlight_left_hover
	elif cutting_right == true:
		# Right arm hit, cut_3
		finger_anims.curr_anim.animation = "cut_3"
		ready_button.text = "PRESS RIGHT / D"
		right_button.texture_normal = highlight_right
		right_button.texture_hover = highlight_right_hover
			
	# Open the scissors and accept player block input
	finger_anims.curr_anim.frame = 0
	block_available = true
	blockable_duration.start()
	

## Failing a block by being late.
func apply_damage():
	if block_success == false and punished == false:
		player_ready = false
		panel.add_theme_stylebox_override("panel", fail_box)
		# FAIL NOISE AND EFFECTS
		Log.add_log_message("IT REACTED TOO LATE AND SUFFERED DAMAGE.")
		ready_button.text = "INCORRECT"
		reset_button_textures()
		block_available = false
		finger_anims.curr_anim.frame = 1
		# TODO: UI text, animations, sound etc.
		var damage_suffered : int = combat_viewport.opponent.damage
		if cutting_left == true:
			damage_arm(limb_array[0], damage_suffered)
		elif cutting_head == true:
			damage_head(combat_viewport.player.head, damage_suffered)
		elif cutting_right == true:
			damage_arm(limb_array[1], damage_suffered)
		if combat_viewport.player_dead == false:
			# Play hurt sound / animation
			combat_viewport.create_timer(combat_viewport.pause_time, play_hit_fx)
			reset_game_state()

## Failing a block by being early, or pressing the wrong button.
func punish(misinput : bool = false):
	if punished == false and block_success == false:
		player_ready = false
		panel.add_theme_stylebox_override("panel", fail_box)
		#TODO: PUNISH NOISE & EFFECTS
		punished = true
		
		finger_anims.curr_anim.pause()
		# Set animation
		if cutting_head == true:
			# Head hit play cut_2
			finger_anims.curr_anim.animation = "cut_2"
		elif cutting_left == true:
			# Left arm hit, cut_1
			finger_anims.curr_anim.animation = "cut_1"
		elif cutting_right == true:
			# Right arm hit, cut_3
			finger_anims.curr_anim.animation = "cut_3"
		finger_anims.curr_anim.frame = 1
		
		if misinput == false:
			Log.add_log_message("IT REACTED TOO EARLY AND SUFFERED DAMAGE.")
			ready_button.text = "TOO\nEARLY"
		else:
			Log.add_log_message("IT BLOCKED FROM THE WRONG DIRECTION AND SUFFERED DAMAGE.")
			ready_button.text = "WRONG\nDIRECTION"
		reset_button_textures()
		block_available = false

		# TODO: UI text, animations, sound etc.
		var damage_suffered : int = combat_viewport.opponent.damage
		if cutting_left == true:
			damage_arm(limb_array[1], damage_suffered)
		elif cutting_head == true:
			damage_head(limb_array[0], damage_suffered)
		elif cutting_right == true:
			damage_arm(limb_array[2], damage_suffered)
	if combat_viewport.player_dead == false:
		# Play hurt sound / animation
		combat_viewport.create_timer(combat_viewport.pause_time, play_hit_fx)
		
		reset_game_state()

func damage_arm(a : Arm, damage : int):
	print("DAMAGE_ARM")
	a.condition -= damage
	if a.condition <= 0:
		combat_viewport.root_ui.arm_fully_eaten(a)
	combat_viewport.root_ui.refresh_temp_labels()
	combat_viewport.player.stat_change.emit()
		
func damage_head(h : Head, damage : int):
	h.damage(damage)
	combat_viewport.check_player_death()
	combat_viewport.root_ui.refresh_temp_labels()
	combat_viewport.player.stat_change.emit()

## Successfully blocking.
func block_attack():
	if punished == false:
		player_ready = false
		panel.add_theme_stylebox_override("panel", success_box)
		#TODO: BLOCK NOISE AND EFFECTS
		Log.add_log_message("IT SUCCESSFULLY BLOCKED THE HIT.")
		reset_button_textures()
		ready_button.text = "MUTILATION\nAVOIDED"
		finger_anims.curr_anim.animation = "default"
		if cutting_left == true:
			finger_anims.curr_anim.frame = 0
		elif cutting_head == true:
			finger_anims.curr_anim.frame = 1
		elif cutting_right == true:
			finger_anims.curr_anim.frame = 2
		block_success = true
		combat_viewport.create_timer(combat_viewport.pause_time, combat_viewport.show_player_turn_start)
		reset_game_state()
		# TODO: Block behavior, text etc.
		pass

func reset_game_state():
	ready_button.disabled = true
	
	blockable_duration.stop()
	blockable_wait_time.stop()
	
	reset_button_textures()
	
	cutting_left = false
	cutting_right = false
	cutting_head  = false
	
	limb_array.clear()

	block_available = false
	player_ready = false
	block_success = false
	punished = false
	
func play_hit_fx():
	visible = false
	combat_viewport.player_anim.hurt_bounce()
	combat_viewport.show_player_turn_start()
	AudioBank.play_rand(combat_viewport.p_speaker, AudioBank.BANK.P_HURT)
	combat_viewport.enemy_anim.animation = "attack"
	combat_viewport.enemy_anim.play()

func open_tutorial():
	if player_ready == false:
		tutorial_container.visible = true

func close_tutorial():
	tutorial_container.visible = false
