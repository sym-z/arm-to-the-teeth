extends Node2D

@export_category("Targets")
@export var tooth_targets : Array[AnimatedSprite2D]
@export var tooth_target_parent : Node2D
@export var center_tooth : AnimatedSprite2D
@export var shift_timer : Timer
@export var shift_interval : float = 0.25
@export_category("Target Pool")
var target_pool : Array[int] = []
# How many frames the targets have
var tooth_types : int = 3
# What index the first tooth is at in the pool
var pool_index : int = 0
@export var total_bursts : int = 15
@export var minimum_burst : int = 3
@export var maximum_burst : int = 5

@export_category("Background")
@export var bg : Sprite2D
@export var hit_bg_color : Color
@export var miss_bg_color : Color
@export var whiff_bg_color : Color

@export_category("Player Control")
@export var flicker : AnimatedSprite2D


func _ready():
	build_tooth_target_arr()
	for tooth in tooth_targets:
		tooth.frame = 0
	create_target_pool()
	initialize_shift_timer()
	
func build_tooth_target_arr():
	for i in range(tooth_target_parent.get_child_count()):
		tooth_targets.append(tooth_target_parent.get_child(i))
	for i in range(tooth_targets.size()):
		var curr_tooth : AnimatedSprite2D = tooth_targets[i]
		if i == 0:
			curr_tooth.is_first = true
			if tooth_targets.size() > 1:
				curr_tooth.next_tooth = tooth_targets[1]
			else:
				curr_tooth.is_last = true
		elif i == tooth_targets.size()-1:
			curr_tooth.is_last = true
			curr_tooth.prev_tooth = tooth_targets[i-1]
		else:
			curr_tooth.next_tooth = tooth_targets[i+1]
			curr_tooth.prev_tooth = tooth_targets[i-1]

# Creates an encoding of frame choices for the teeth.
func create_target_pool():
	for num in total_bursts:
		#target_pool.append(randi_range(0,tooth_types-1))
		var rand_type = randi_range(0, tooth_types-1)
		burst(randi_range(minimum_burst,maximum_burst), rand_type)
	for num in tooth_targets.size():
		target_pool.append(0)

# Teeth pool is generated out of bursts of likewise teeth
func burst(amount : int, type : int):
	for i in range(amount):
		target_pool.append(type)

func initialize_shift_timer():
	shift_timer.wait_time = shift_interval
	shift_timer.connect("timeout", shift_teeth)
	shift_timer.start()
func shift_teeth():
	if pool_index < target_pool.size():
		tooth_targets[0].set_new_frame(target_pool[pool_index])
		pool_index += 1
	#else:
		## Minigame finished
		#print("done")

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("move_forward"):
		flicker.flick()
		match center_tooth.frame:
			center_tooth.TYPE.HIT:
				print("hit")
				bg.modulate = hit_bg_color
			center_tooth.TYPE.MISS:
				print("miss")
				bg.modulate = miss_bg_color
			center_tooth.TYPE.WHIFF:
				print("whiff")
				bg.modulate = whiff_bg_color
		var frame_ref = center_tooth.frame
		center_tooth.animation = "broken"
		center_tooth.frame = frame_ref
	elif event.is_action("turn_left"):
		if event.is_action_pressed("turn_left"):
			flicker.block_left()
		elif event.is_action_released("turn_left"):
			flicker.reset_animation()
	elif event.is_action("turn_right"):
		if event.is_action_pressed("turn_right"):
			flicker.block_right()
		elif event.is_action_released("turn_right"):
			flicker.reset_animation()
	elif event.is_action("move_back"):
		if event.is_action_pressed("move_back"):
			flicker.block_down()
		elif event.is_action_released("move_back"):
			flicker.reset_animation()
	
