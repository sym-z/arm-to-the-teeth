extends MarginContainer
@export var combat_viewport : MarginContainer
@export var finger_anims : Node2D
@export var timer : Timer

var limb_array : Array[Variant] = []
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func begin_game():
	# Identify number of equipped limbs
	var num_limbs : int = 1
	# Will always be more than one to include head
	# Add limbs to array
	
	limb_array.append(combat_viewport.player.head)
	for arm in combat_viewport.player.arm_inventory:
		if arm.equipped == true:
			num_limbs += 1
			limb_array.append(arm)
	# Set animation
	finger_anims.set_finger_number(num_limbs)
	print("NUM LIMBS: ", num_limbs)
	finger_anims.curr_anim.play()
	
	
	if limb_array.size() -1 > 3:
		push_error("Incorrect number of limbs equipped in begin_game() function in finger_react.gd")
		return
		
	# Will eventually be initiated by the press of a button labelled "READY?"
	rand_wait()
	
func rand_wait():
	var rand_time : float = randf_range(1.0,3.5)
	timer.wait_time = rand_time
	timer.start()
	

func cut_finger():
	# Calculate which limb will be hit
	var rand_choice = randi_range(0,limb_array.size()-1)
	
	match rand_choice:
		0:
			# Head hit play cut_2
			finger_anims.curr_anim.animation = "cut_2"
		1:
			# Left arm hit, cut_1
			finger_anims.curr_anim.animation = "cut_1"
		2:
			# Right arm hit, cut_3
			finger_anims.curr_anim.animation = "cut_3"
			
	finger_anims.curr_anim.play()
	
	# Apply damage
	pass
