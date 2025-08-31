extends MarginContainer

@export var combat_viewport : MarginContainer

@export_category("Animations")
@export var wheel : AnimatedSprite2D
@export var clicker : AnimatedSprite2D

@export_category("Labels")
@export var result_label : Label

@export_category("Buttons")
@export var stop_button : Button

@export_category("Styleboxes")
@export var panel : Panel
@export var default_box : StyleBoxFlat
@export var miss_box : StyleBoxFlat
@export var light_hit_box : StyleBoxFlat
@export var heavy_hit_box : StyleBoxFlat
@export var crit_box : StyleBoxFlat
@export var light_whiff_box : StyleBoxFlat
@export var med_whiff_box : StyleBoxFlat
@export var heavy_whiff_box : StyleBoxFlat

@export_category("Audio")
@export var speaker : AudioStreamPlayer

var attacking_limb
var is_head : bool
var debuff : float
var wheel_stopped : bool = false
var result_network : Dictionary[int,Callable] = {
	0 : crit,
	1 : whiff_heavy,
	2 : whiff_medium,
	3 : whiff_light,
	4 : hit_light,
	5 : hit_light,
	6 : hit_heavy,
	7 : hit_light,
	8 : hit_light,
	9 : miss,
	10 : miss,
	11 : miss,
	12 : hit_light,
	13 : hit_light,
	14 : hit_heavy,
	15 : hit_light,
	16 : hit_light,
	17 : whiff_light,
	18 : whiff_medium,
	19 : whiff_heavy
}
var result_text : Dictionary[int,String] = {
	0 : "CRIT!",
	1 : "HEAVY WHIFF",
	2 : "MEDIUM WHIFF",
	3 : "LIGHT WHIFF",
	4 : "LIGHT HIT!",
	5 : "LIGHT HIT!",
	6 : "HEAVY HIT!",
	7 : "LIGHT HIT!",
	8 : "LIGHT HIT!",
	9 : "MISS",
	10 : "MISS",
	11 : "MISS",
	12 : "LIGHT HIT!",
	13 : "LIGHT HIT!",
	14 : "HEAVY HIT!",
	15 : "LIGHT HIT!",
	16 : "LIGHT HIT!",
	17 : "LIGHT WHIFF",
	18 : "MEDIUM WHIFF",
	19 : "HEAVY WHIFF"
}
var result_stylebox : Dictionary[int, StyleBoxFlat] = {}
# Called when the node enters the scene tree for the first time.
func _ready():
	wheel.connect("frame_changed", change_label)
	stop_button.connect("button_down", stop_wheel)
	
	result_stylebox = {
	0 : crit_box,
	1 : heavy_whiff_box,
	2 : med_whiff_box,
	3 : light_whiff_box,
	4 : light_hit_box,
	5 :  light_hit_box,
	6 :  heavy_hit_box,
	7 :  light_hit_box,
	8 :  light_hit_box,
	9 :  miss_box,
	10 : miss_box,
	11 : miss_box,
	12 : light_hit_box,
	13 : light_hit_box,
	14 : heavy_hit_box,
	15 : light_hit_box,
	16 : light_hit_box,
	17 : light_whiff_box,
	18 : med_whiff_box,
	19 : heavy_whiff_box 
}
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func change_label():
	result_label.text = result_text[wheel.frame]
	
func spin_wheel(limb : Variant, head : bool):
	# Hide arm management
	combat_viewport.change_arm_select_vis(false)
	# Show window
	combat_viewport.change_wheel_roller_vis(true)
	wheel_stopped = false
	panel.add_theme_stylebox_override("panel", default_box)
	# Set the references
	attacking_limb = limb
	is_head = head
	debuff = combat_viewport.player.attack_debuff
	# Set to random frame
	wheel.frame = randi_range(0,wheel.sprite_frames.get_frame_count("default")-1)
	change_label()
	if Globals.curr_floor != 0:
		if Globals.verbose_console == true:
			print("WITHOUT DEBUFF: ", wheel.speed_scale + log(Globals.curr_floor**3))
			print("WITH DEBUFF: ", wheel.speed_scale + log(Globals.curr_floor**3) / combat_viewport.player.attack_debuff)
		wheel.speed_scale = min(10,1.0 + log(Globals.curr_floor**3) / combat_viewport.player.attack_debuff)
	else:
		wheel.speed_scale = min(10, 1.0 / combat_viewport.player.attack_debuff)
	wheel.play()

func stop_wheel():
	if wheel_stopped == false:
		wheel_stopped = true
		wheel.pause()
		panel.add_theme_stylebox_override("panel", result_stylebox[wheel.frame])
		result_network[wheel.frame].call()


func crit():
	AudioBank.play_rand(speaker, AudioBank.BANK.WR_CRIT)
	hit_enemy(attacking_limb.strength * 5)
	

func whiff_heavy():
	AudioBank.play_rand(speaker, AudioBank.BANK.WR_H_WHIFF)
	if is_head == true:
		whiff(max(1,floor(attacking_limb.max_health * 0.5)))
	else:
		whiff(max(1,floor(attacking_limb.max_condition * 0.5)))
func whiff_medium():
	AudioBank.play_rand(speaker, AudioBank.BANK.WR_M_WHIFF)
	if is_head == true:
		whiff(max(1,floor(attacking_limb.max_health * 0.25)))
	else:
		whiff(max(1,floor(attacking_limb.max_condition * 0.25)))
func whiff_light():
	AudioBank.play_rand(speaker, AudioBank.BANK.WR_L_WHIFF)
	if is_head == true:
		whiff(max(1,floor(attacking_limb.max_health * 0.1)))
	else:
		whiff(max(1,floor(attacking_limb.max_condition * 0.1)))
func hit_heavy():
	AudioBank.play_rand(speaker, AudioBank.BANK.WR_H_HIT)
	hit_enemy(attacking_limb.strength * 2)
	
func hit_light():
	AudioBank.play_rand(speaker, AudioBank.BANK.WR_L_HIT)
	hit_enemy(attacking_limb.strength)
	
func miss():
	AudioBank.play_rand(speaker, AudioBank.BANK.WR_MISS)
	Log.add_log_message("IT MISSED ITS ATTACK")
	combat_viewport.create_timer(combat_viewport.pause_time, combat_viewport.finger_react.begin_game)

func hit_enemy(damage: int):
	if Globals.verbose_console == true:
		print("HUNGER DEBUFF: ", debuff, " ORIGINAL DAMAGE: ", damage)
	# Apply hunger effects, if any.
	damage = max(roundi(damage * debuff),1)
	if Globals.verbose_console == true:
		print("ACTUAL DAMAGE: " , damage)
	# Prevent negative hp in enemy stat label
	combat_viewport.opponent.curr_health = max(0, combat_viewport.opponent.curr_health - damage)
	Log.add_log_message("IT DEALT " + str(damage) + " DAMAGE.")
	combat_viewport.refresh_temp_labels()
		
	if combat_viewport.opponent.curr_health <= 0:
		combat_viewport.create_timer(combat_viewport.pause_time, play_dead_enemy_fx)
	else:
		combat_viewport.create_timer(combat_viewport.pause_time, play_hurt_enemy_fx)
		

func whiff(damage: int):
	if is_head == true:
		# Head loses health, and teeth are lost. Possibly roll for teeth lost.
		#TODO: Have low rolls factor into more health and teeth lost
		Log.add_log_message("IT WHIFFED AND DEALTH " + str(damage) + " DAMAGE TO ITS HEAD.")
		attacking_limb.damage(damage)
		#combat_viewport.player.stat_change.emit()
		# Refresh root_ui's labels
		# Check for player death.
		combat_viewport.check_player_death()
	else:
		attacking_limb.condition -= damage
		if attacking_limb.condition <= 0:
			Log.add_log_message("IT WHIFFED ITS ATTACK AND ITS ARM WAS DAMAGED BEYOND USE.")
			combat_viewport.root_ui.arm_fully_eaten(attacking_limb)
		else:
			Log.add_log_message("IT WHIFFED ITS ATTACK GOT HURT, ARM LOST " + str(damage) + " CONDITION.")
			# Only emitting here because when an arm is fully eaten the signal will fire.
			
	combat_viewport.root_ui.refresh_temp_labels()
	combat_viewport.player.stat_change.emit()
	
	
	# Even if the player kills the enemy, this function will attempt to be called, but since combat_viewport.enemy_dead == true, it wont matter
	if combat_viewport.player_dead == false:
		combat_viewport.create_timer(combat_viewport.pause_time, play_hurt_player_fx)

func play_hurt_player_fx():
	#TODO: ENEMY ATTACK NOISE
	visible = false
	combat_viewport.player_anim.hurt_bounce()
	AudioBank.play_rand(combat_viewport.p_speaker, AudioBank.BANK.P_WHIFF)
	combat_viewport.create_timer(combat_viewport.pause_time, combat_viewport.finger_react.begin_game)
	pass
func play_hurt_enemy_fx():
	visible = false
	combat_viewport.player_anim.attack_bounce()
	AudioBank.play_rand(combat_viewport.p_speaker, AudioBank.BANK.P_ATT)
	combat_viewport.enemy_anim.animation = "hurt"
	combat_viewport.enemy_anim.play()
	AudioBank.play_rand(combat_viewport.e_speaker, AudioBank.BANK.E_HURT)
	combat_viewport.create_timer(combat_viewport.pause_time, combat_viewport.finger_react.begin_game)

func play_dead_enemy_fx():
	visible = false
	combat_viewport.player_anim.attack_bounce()
	AudioBank.play_rand(combat_viewport.p_speaker, AudioBank.BANK.P_CRIT)
	combat_viewport.enemy_anim.animation = "death"
	combat_viewport.enemy_anim.play()
	AudioBank.play_rand(combat_viewport.e_speaker, AudioBank.BANK.E_DEATH)
	combat_viewport.create_timer(combat_viewport.pause_time,combat_viewport.check_enemy_death)
