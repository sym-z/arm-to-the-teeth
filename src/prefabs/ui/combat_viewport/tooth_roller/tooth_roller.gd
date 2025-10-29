extends Node2D

@export var tooth_targets : Array[AnimatedSprite2D]
@export var tooth_target_parent : Node2D
@export var center_tooth : AnimatedSprite2D
@export var shift_timer : Timer
@export var shift_interval : float = 0.25
# How many teeth roll in.
@export var target_pool_size : int = 25
var target_pool : Array[int] = []
# How many frames the targets have
var tooth_types : int = 3
# What index the first tooth is at in the pool
var pool_index : int = 0

@export var bg : Sprite2D
@export var hit_bg_color : Color
@export var miss_bg_color : Color
@export var whiff_bg_color : Color
func _ready():
	build_tooth_target_arr()
	for tooth in tooth_targets:
		tooth.frame = 0
	create_target_pool(target_pool_size)
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
		print("TOOTH: ", i)

# Creates an encoding of frame choices for the teeth.
func create_target_pool(size : int):
	for num in size:
		target_pool.append(randi_range(0,tooth_types-1))
	for num in tooth_targets.size():
		target_pool.append(0)

func initialize_shift_timer():
	shift_timer.wait_time = shift_interval
	shift_timer.connect("timeout", shift_teeth)
	shift_timer.start()
func shift_teeth():
	if pool_index < target_pool.size():
		tooth_targets[0].set_new_frame(target_pool[pool_index])
		pool_index += 1

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("move_forward"):
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
		
			
		#tooth_targets[0].set_new_frame(2)
	#elif event.is_action_pressed("ui_down"):
		#tooth_targets[0].set_new_frame(1)
