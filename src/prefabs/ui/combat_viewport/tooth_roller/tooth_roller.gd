extends Node2D
## Combat Viewport Reference
@export var cv : MarginContainer
@export var testing_mode : bool = false
@export_category("Targets")
@export var tooth_targets : Array[AnimatedSprite2D]
@export var tooth_target_parent : Node2D
@export var center_tooth : AnimatedSprite2D
@export var shift_timer : Timer
## How fast the teeth move
@export var shift_interval : float = 0.25
@export_category("Target Pool")
var target_pool : Array[int] = []
# How many frames the targets have
var tooth_types : int = 3
enum TYPE{MISS = 0, HIT = 1, WHIFF = 2}
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

@export_category("Tooth Type Chance")
var rng : RandomNumberGenerator
var weights : PackedFloat32Array = []
@export var empty_weight : float = 0.2
@export var whiff_weight : float = 0.4
@export var hit_weight : float = 0.6

@export_category("Tongue Attack")
@export var tongue_attack : Node2D
@export var creep_time : float = 1.0
@export var attack_time : float = 0.25
@export var cooldown_timer : Timer
@export var start_timer : Timer
# How many times the player has been hit
var tongue_attacks : int = 0
var attacking_tongue : AnimatedSprite2D = null


var hits : float = 0
var misses : float = 0
var whiffs : float = 0 

var hit_mult : float = 1.0
var whiff_mult : float = 1.0

# Last hit read
var last_action : TYPE = TYPE.MISS

var player_score = 0
var enemy_score = 0
var enemy_alive : bool = true

var attacking_limb
var is_head : bool

@export_category("Speakers")
@export var hit_speaker : AudioStreamPlayer
@export var whiff_speaker : AudioStreamPlayer
@export var tongue_attack_speaker : AudioStreamPlayer
@export_category("Hurt Shader")
@export var hurt_timer : Timer
@export var gum_frame : Sprite2D
var hurt_mat : Material = preload("uid://y4e7haviwsyu")
#TODO: TUNE DIFFICULTY PER FLOOR
func hurt_animation():
	material = hurt_mat
	pass
func hurt_animation_cleanup():
	tooth_target_parent.material = null
	gum_frame.material=null
	pass
func _ready():
	visible = false
	hurt_timer.connect("timeout", hurt_animation_cleanup)
	build_tooth_target_arr()
	weight_randomness()
	initialize_shift_timer()
	init_tongue()
	
	if testing_mode == true:
		begin_game(null, false)


func begin_game(limb : Variant, head : bool):
	if testing_mode == false:
		attacking_limb = limb
		is_head = head
	visible = true
	target_pool.clear()
	create_target_pool()
	cv.change_arm_select_vis(false)
	shift_timer.start()
	start_timer.start()
	
	
# Builds and links tooth targets together
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
	# Initialize all teeth to be invisible
	for tooth in tooth_targets:
		tooth.frame = 0

# Creates an encoding of frame choices for the teeth.
func create_target_pool():
	# Pool of indices of possible types, to be selected using weighted rng
	var choice_arr : Array[int] = []
	for i in range(tooth_types):
		choice_arr.append(i)
	for num in total_bursts:
		#target_pool.append(randi_range(0,tooth_types-1))
		#var rand_type = randi_range(0, tooth_types-1)
		var rand_type = choice_arr[rng.rand_weighted(weights)]
		burst(randi_range(minimum_burst,maximum_burst), rand_type)
	for num in tooth_targets.size():
		target_pool.append(0)

func weight_randomness():
	rng = RandomNumberGenerator.new()
	weights.resize(tooth_types)
	weights[TYPE.MISS] = empty_weight
	weights[TYPE.WHIFF] = whiff_weight
	weights[TYPE.HIT] = hit_weight

# Teeth pool is generated out of bursts of likewise teeth
func burst(amount : int, type : int):
	for i in range(amount):
		target_pool.append(type)

func initialize_shift_timer():
	shift_timer.wait_time = shift_interval
	shift_timer.connect("timeout", shift_teeth)

func shift_teeth():
	
	if pool_index < target_pool.size():
		tooth_targets[0].set_new_frame(target_pool[pool_index])
		pool_index += 1
	elif testing_mode == false:
		## Minigame finished
		shift_timer.stop()
		# Current Idea:
		# 1 Hit is + 0.25 * Weapon Strength
		# 1 Whiff is - 0.25 * weapon strength
		# if final calc is negative, hurt the attacking limb
		# Apply # of hits from tongues * enemy strength to attacking arm
		print("HITS: ", hits)
		print("MISSES: ", misses)
		print("WHIFFS: ", whiffs)
		print("TONGUE ATTACKS: ", tongue_attacks)
		print("HIT MULT ", hit_mult )
		print("WHIFF MULT ", whiff_mult)
		#TODO APPLY HUNGER DEBUFF
		player_score = floor(((hits) - (whiffs)) * attacking_limb.strength)
		# Make it so if the player lands at least one hit/one whiff something happens.
		if player_score == 0:
			if hits - whiffs > 0:
				player_score = 1
			elif hits - whiffs < 0:
				player_score = -1
		enemy_score = tongue_attacks * cv.opponent.damage
		print("PLAYER: ", player_score, " ENEMY: ", enemy_score)
		enemy_results()
	else:
		pass
		## ENEMY ATTACK
		
func player_results():
	print("player results called")
	#visible = true
	if player_score >= 0:
		#TODO: HIT ENEMY
		cv.opponent.curr_health = max(0, cv.opponent.curr_health - player_score)
		Log.add_log_message("IT DEALT " + str(int(player_score)) + " DAMAGE.")
		cv.refresh_temp_labels()
		if cv.opponent.curr_health <= 0:
			#cv.create_timer(cv.pause_time, play_dead_enemy_fx)
			play_dead_enemy_fx()
		else:
			#cv.create_timer(cv.pause_time, play_hurt_enemy_fx)
			play_hurt_enemy_fx()
	else:
		if is_head == true:
			Log.add_log_message("IT WHIFFED AND DEALTH " + str(-player_score) + " DAMAGE TO ITS HEAD.")
			attacking_limb.damage(-player_score)
			# Refresh root_ui's labels
			# Check for player death.
			cv.check_player_death()
		else:
			attacking_limb.condition -= -player_score 
			if attacking_limb.condition <= 0:
				Log.add_log_message("IT WHIFFED ITS ATTACK AND ITS ARM WAS DAMAGED BEYOND USE.")
				cv.root_ui.arm_fully_eaten(attacking_limb)
			else:
				Log.add_log_message("IT WHIFFED ITS ATTACK GOT HURT, ARM LOST " + str(-player_score) + " CONDITION.")
				# Only emitting here because when an arm is fully eaten the signal will fire.
		play_hurt_player_fx()
		cv.root_ui.refresh_temp_labels()
		cv.player.stat_change.emit()
	game_reset()
	
	

func enemy_results():
	if enemy_score > 0:
		if is_head == true:
			attacking_limb.damage(enemy_score*cv.opponent.damage)
			cv.check_player_death()
			cv.root_ui.refresh_temp_labels()
			cv.player.stat_change.emit()
		else:
			attacking_limb.condition -= enemy_score*cv.opponent.damage
			if attacking_limb.condition <= 0:
				cv.root_ui.arm_fully_eaten(attacking_limb)
			cv.root_ui.refresh_temp_labels()
			cv.player.stat_change.emit()
		play_enemy_attack_fx()
		cv.create_timer(cv.pause_time, player_results)
	else:
		#visible = false
		#game_reset()
		#cv.show_player_turn_start()
		player_results()
			
func game_reset():
	print("game reset called")
	pool_index = 0
	attacking_tongue = null
	cooldown_timer.stop()
	start_timer.stop()
	hits = 0
	misses = 0
	whiffs = 0
	hit_mult = 1.0
	whiff_mult = 1.0
	last_action = TYPE.MISS
	tongue_attacks = 0
	player_score = 0
	enemy_score = 0
	bg.modulate=Color(1,1,1,1)
	if enemy_alive == true:
		cv.create_timer(cv.pause_time, cv.show_player_turn_start)
	else:
		cv.create_timer(cv.pause_time,cv.check_enemy_death)
		enemy_alive = true
	pass
func play_hurt_player_fx():
	#TODO: ENEMY ATTACK NOISE
	visible = false
	cv.player_anim.hurt_bounce()
	AudioBank.play_rand(cv.p_speaker, AudioBank.BANK.P_WHIFF)
	#cv.create_timer(cv.pause_time, cv.show_player_turn_start)

func play_hurt_enemy_fx():
	visible = false
	print("PLAYIN ENEMY HURT", player_score)
	if player_score > 0:
		cv.player_anim.attack_bounce()
		AudioBank.play_rand(cv.p_speaker, AudioBank.BANK.P_ATT)
		cv.enemy_anim.animation = "hurt"
		cv.enemy_anim.play()
		AudioBank.play_rand(cv.e_speaker, AudioBank.BANK.E_HURT)
		#cv.create_timer(cv.pause_time, cv.show_player_turn_start)
	#else:
		##cv.show_player_turn_start()


func play_dead_enemy_fx():
	visible = false
	cv.player_anim.attack_bounce()
	AudioBank.play_rand(cv.p_speaker, AudioBank.BANK.P_CRIT)
	cv.enemy_anim.animation = "death"
	cv.enemy_anim.play()
	AudioBank.play_rand(cv.e_speaker, AudioBank.BANK.E_DEATH)
	enemy_alive = false
	


func play_enemy_attack_fx():
	visible = false
	if enemy_score > 0:
		cv.player_anim.hurt_bounce()
		#cv.show_player_turn_start()
		AudioBank.play_rand(cv.p_speaker, AudioBank.BANK.P_HURT)
		cv.enemy_anim.animation = "attack"
		cv.enemy_anim.play()


	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("move_forward"):
		flicker.flick()
		match center_tooth.frame:
			TYPE.HIT:
				#print("hit")
				bg.modulate = hit_bg_color
				hits += 1 * hit_mult
				if last_action == TYPE.HIT:
					hit_mult += 0.2
				else:
					last_action = TYPE.HIT
					whiff_mult = 1.0
				hit_speaker.play()
				# Add to hit mult or reset whiff mult
			TYPE.MISS:
				#print("miss")
				bg.modulate = miss_bg_color
				misses += 1 
				# Reset both mults
				hit_mult = 1.0
				whiff_mult = 1.0
			TYPE.WHIFF:
				#print("whiff")
				bg.modulate = whiff_bg_color
				whiffs += 1*whiff_mult
				if last_action == TYPE.WHIFF:
					whiff_mult += 0.2
				else:
					last_action == TYPE.WHIFF
					hit_mult = 1.0
				# Reset hit mult or contribute to whiff mult
		var frame_ref = center_tooth.frame
		center_tooth.animation = "broken"
		center_tooth.frame = frame_ref
	elif event.is_action("turn_left"):
		if event.is_action_pressed("turn_left"):
			flicker.block_left()
			if attacking_tongue:
				if tongue_attack.left == attacking_tongue:
					#print("blocked left success")
					attacking_tongue.block()
					attacking_tongue = null
				else:
					attacking_tongue.force_attack()
					tongue_attack_speaker.play()
					attacking_tongue = null
					tongue_attacks += 1
		elif event.is_action_released("turn_left") and flicker.is_blocking and flicker.block_direction == flicker.DIR.LEFT:
			flicker.reset_animation()
	elif event.is_action("turn_right"):
		if event.is_action_pressed("turn_right"):
			flicker.block_right()
			if attacking_tongue:
				if tongue_attack.right == attacking_tongue:
					#print("blocked right success")
					attacking_tongue.block()
					attacking_tongue = null
				else:
					attacking_tongue.force_attack()
					tongue_attack_speaker.play()
					attacking_tongue = null
					tongue_attacks += 1
		elif event.is_action_released("turn_right") and flicker.is_blocking and flicker.block_direction == flicker.DIR.RIGHT:
			flicker.reset_animation()
	elif event.is_action("move_back"):
		if event.is_action_pressed("move_back"):
			flicker.block_down()
			if attacking_tongue:
				if tongue_attack.down == attacking_tongue:
					#print("blocked down success")
					attacking_tongue.block()
					attacking_tongue = null
				else:
					attacking_tongue.force_attack()
					tongue_attack_speaker.play()
					attacking_tongue = null
					tongue_attacks += 1
		elif event.is_action_released("move_back") and flicker.is_blocking and flicker.block_direction == flicker.DIR.DOWN:
			flicker.reset_animation()


func init_tongue():
	cooldown_timer.connect("timeout", tongue_trigger)
	start_timer.connect("timeout", tongue_trigger)
	tongue_attack.connect("start_cooldown", tongue_cooldown)
	tongue_attack.connect("start_attack", creep_to_attack)
	# After random time, call first tongue attack
	start_timer.wait_time = randf_range(0.25,1.0)
	
	pass


func tongue_trigger():
	#print("TRIGGER")
	#print(pool_index*shift_interval, " / " ,target_pool.size() * shift_interval)
	var current_time : float = pool_index*shift_interval
	var total_time : float = target_pool.size() * shift_interval
	
	var attack_window : float = creep_time + attack_time
	#print("curr", current_time)
	#print("total", total_time)
	#print("window", attack_window)
	if attack_window < total_time - current_time:
		#print("ATTEMPT")
		attacking_tongue = tongue_attack.get_random_tongue()
		if attacking_tongue:
			attacking_tongue.creep(creep_time)
		# Choose random direction
		# Attack
		# Start random cool down

func tongue_cooldown():
	#print("cooling down")
	cooldown_timer.wait_time = randf_range(1.0,1.5)
	cooldown_timer.start()
	
func creep_to_attack():
	attacking_tongue.attack(attack_time)
	tongue_attack_speaker.play()
	flicker.play_hurt()
	attacking_tongue = null
	tongue_attacks += 1
