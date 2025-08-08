extends MarginContainer

@export var combat_viewport : MarginContainer

@export_category("Animations")
@export var wheel : AnimatedSprite2D
@export var clicker : AnimatedSprite2D

@export_category("Labels")
@export var result_label : Label

@export_category("Buttons")
@export var stop_button : Button


var attacking_limb
var is_head : bool
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
# Called when the node enters the scene tree for the first time.
func _ready():
	wheel.connect("frame_changed", change_label)
	stop_button.connect("button_down", stop_wheel)
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
	# Set the references
	attacking_limb = limb
	is_head = head
	# Set to random frame
	wheel.frame = randi_range(0,wheel.sprite_frames.get_frame_count("default")-1)
	change_label()
	wheel.play()

func stop_wheel():
	wheel.pause()
	result_network[wheel.frame].call()
	# Enable inventory management and hide window
	combat_viewport.change_wheel_roller_vis(false)
	# Even if the player kills the enemy, this function will attempt to be called, but since combat_viewport.enemy_dead == true, it wont matter
	if combat_viewport.enemy_dead == false:
		combat_viewport.create_timer(combat_viewport.pause_time, combat_viewport.enemy_attack_roll)

func crit():
	hit_enemy(attacking_limb.strength * 5)

func whiff_heavy():
	if is_head == true:
		whiff(floor(attacking_limb.max_health * 0.5))
	else:
		whiff(floor(attacking_limb.max_condition * 0.5))
func whiff_medium():
	if is_head == true:
		whiff(floor(attacking_limb.max_health * 0.25))
	else:
		whiff(floor(attacking_limb.max_condition * 0.25))
func whiff_light():
	if is_head == true:
		whiff(floor(attacking_limb.max_health * 0.1))
	else:
		whiff(floor(attacking_limb.max_condition * 0.1))
func hit_heavy():
	hit_enemy(attacking_limb.strength * 2)
func hit_light():
	hit_enemy(attacking_limb.strength)
func miss():
	Log.add_log_message("IT MISSED ITS ATTACK")

func hit_enemy(damage: int):
	# Prevent negative hp in enemy stat label
	combat_viewport.opponent.curr_health = max(0, combat_viewport.opponent.curr_health - damage)
	Log.add_log_message("IT DEALT " + str(damage) + " DAMAGE.")
	combat_viewport.refresh_temp_labels()
	combat_viewport.check_enemy_death()

func whiff(damage: int):
	if is_head == true:
		# Head loses health, and teeth are lost. Possibly roll for teeth lost.
		#TODO: Have low rolls factor into more health and teeth lost
		Log.add_log_message("IT WHIFFED AND DEALTH " + str(damage) + " DAMAGE TO ITS HEAD.")
		attacking_limb.damage(damage)
		combat_viewport.player.stat_change.emit()
		# Refresh root_ui's labels
		combat_viewport.root_ui.refresh_temp_labels()
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
			combat_viewport.player.stat_change.emit()
