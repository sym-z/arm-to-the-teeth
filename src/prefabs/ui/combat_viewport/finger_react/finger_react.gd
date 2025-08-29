extends MarginContainer
@export var combat_viewport : MarginContainer
@export var finger_anims : Node2D
@export var blockable_wait_time: Timer
@export var blockable_duration : Timer

@export_category("Containers")
@export var left_container : MarginContainer
@export var head_container : MarginContainer
@export var right_container : MarginContainer

@export_category("Buttons")
@export var left_button : TextureButton
@export var head_button : TextureButton
@export var right_button : TextureButton
@export var ready_button : Button

var highlight_left : CompressedTexture2D = preload("uid://bk1434tm4rg5j")
var highlight_head : CompressedTexture2D = preload("uid://byb6swm1xbyb0")
var highlight_right : CompressedTexture2D = preload("uid://coddoaf01a0cg")

var highlight_left_hover : CompressedTexture2D = preload("uid://cs6d7r8xxbs5t")
var highlight_head_hover : CompressedTexture2D = preload("uid://ba4kehfjmxe63")
var highlight_right_hover : CompressedTexture2D = preload("uid://pmqf7w2y2r0w")

var default_left : CompressedTexture2D = preload("uid://b3am1sni15h2b")
var default_head : CompressedTexture2D = preload("uid://b7ntjjx5drk2q")
var default_right : CompressedTexture2D = preload("uid://badpw3mu3fsl1")

var cutting_left : bool = false
var cutting_right : bool = false
var cutting_head : bool = false

var limb_array : Array[Variant] = []

# When this is true a block can be registered
var block_available : bool = false
var player_ready : bool = false
var block_success : bool = false
# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _input(event):
	if player_ready == true:
		if combat_viewport.player.in_combat == true:
			if event.is_action_pressed("turn_left"):
				if block_available == true and cutting_left == true:
					block_attack()
				else:
					#TODO: Punish
					print("PUNISH")
					pass
				pass
			elif event.is_action_pressed("move_forward"):
				if block_available == true and cutting_head == true:
					block_attack()
				else:
					#TODO: Punish
					pass
				pass
			elif event.is_action_pressed("turn_right"):
				if block_available == true and cutting_right == true:
					block_attack()
				else:
					#TODO: Punish
					pass
				pass

func begin_game():
	reset_button_textures()
	# TODO: Adjust this for difficulty based on floor level and hunger
	blockable_duration.wait_time = 1.8
	
	# Identify number of equipped limbs
	# Will always be more than one to include head
	# Add limbs to array
	limb_array.append(combat_viewport.player.head)
	for arm in combat_viewport.player.arm_inventory:
		if arm.equipped == true:
			limb_array.append(arm)
	# Set animation
	finger_anims.set_finger_number(limb_array.size())
	print("NUM LIMBS: ", limb_array.size)
	finger_anims.curr_anim.play()
	
	if limb_array.size() -1 > 3:
		push_error("Incorrect number of limbs equipped in begin_game() function in finger_react.gd")
		return
	
	# Only show relevent gui
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
func rand_wait():
	player_ready = true
	ready_button.text = "GOOD LUCK."
	var rand_time : float = randf_range(1.0,3.5)
	blockable_wait_time.wait_time = rand_time
	blockable_wait_time.start()
	

func cut_finger():
	# Calculate which limb will be hit
	var rand_choice = randi_range(0,limb_array.size()-1)
	print("cut_finger")
	finger_anims.curr_anim.pause()
	match rand_choice:
		0:
			# Head hit play cut_2
			finger_anims.curr_anim.animation = "cut_2"
			cutting_left = false
			cutting_head = true
			cutting_right = false
			ready_button.text = "PRESS UP / W"
			head_button.texture_normal = highlight_head
			head_button.texture_hover = highlight_head_hover
		1:
			# Left arm hit, cut_1
			finger_anims.curr_anim.animation = "cut_1"
			cutting_left = true
			cutting_head = false
			cutting_right = false
			ready_button.text = "PRESS LEFT / A"
			left_button.texture_normal = highlight_left
			left_button.texture_hover = highlight_left_hover
			
		2:
			# Right arm hit, cut_3
			finger_anims.curr_anim.animation = "cut_3"
			cutting_left = false
			cutting_head = false
			cutting_right = true
			ready_button.text = "PRESS RIGHT / D"
			right_button.texture_normal = highlight_right
			right_button.texture_hover = highlight_right_hover
			
	# Open the scissors and accept player block input
	finger_anims.curr_anim.frame = 0
	block_available = true
	blockable_duration.start()

func apply_damage():
	if block_success == false:
		reset_button_textures()
		print("BLOCK FAILED")
		block_available = false
		finger_anims.curr_anim.frame = 1
		# TODO: Damage, text, etc.
	if cutting_left == true:
		# Damage limb_arr[0]
		pass
	elif cutting_head == true:
		# player.head.damage
		pass
	elif cutting_right == true:
		# Damage limb_arr[1]
		pass

func block_attack():
	print("BLOCKED!!!")
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
	# TODO: Block behavior, text etc.
	pass


func _on_left_arrow_pressed():
	if block_available == true and cutting_left == true:
		block_attack()
	elif player_ready == false:
		pass
	else:
	#TODO: Punish
		print("PUNISH")


func _on_up_arrow_pressed():
	if block_available == true and cutting_head == true:
		block_attack()
	elif player_ready == false:
		pass
	else:
	#TODO: Punish
		print("PUNISH")



func _on_right_arrow_pressed():
	if block_available == true and cutting_right == true:
		block_attack()
	elif player_ready == false:
		pass
	else:
	#TODO: Punish
		print("PUNISH")
