extends MarginContainer

var opponent : Enemy 

@export_category("Dialog Box Button Choices")
@export var button_container : HBoxContainer
@export var attack_button : Button
@export var run_button : Button

@export_category("Dialog Box Die Rollers")
@export var att_die_roller : AnimatedSprite2D

@export_category("Animations")
@export var player_anim : AnimatedSprite2D
@export var enemy_anim : AnimatedSprite2D

@export_category("TEMP ENEMY STATS")
@export var temp_e_health : Label
@export var temp_e_damage : Label

enum TURN {PLAYER,ENEMY}
var curr_turn : TURN = TURN.PLAYER
func _ready():
	visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func begin_combat(e : Enemy, loc : Vector2i):
	Log.add_log_message("IT HAS ENTERED COMBAT")
	visible = true
	att_die_roller.visible = false
	print("COMBAT BEGAN WITH ")
	e.debug_print()
	print("AT ", loc)
	opponent = e
	refresh_temp_labels()
	if e.anim != null:
		enemy_anim.sprite_frames = e.anim
	
func refresh_temp_labels():
	temp_e_health.text = "HEALTH: " + str(opponent.curr_health) + "/" + str(opponent.total_health)
	temp_e_damage.text = "DAMAGE: " + str(opponent.damage)
	pass

#region Combat Loop
func _on_attack_pressed():
	button_container.visible = false
	att_die_roller.visible = true
	#TODO: Adjust bounds depending on arm conditions etc.
	#TODO: MAKE ARM CHOICE HERE, NEED TO MAKE ARM CHOICE WINDOW IN DIALOG BOX, GIVE REFERENCE TO PLAYER LIKE MINIMAP
	att_die_roller.set_die(1,20,opponent.difficulty_class)
	#TODO: SET LABEL TO SHOW DIFFICULTY CLASS
	
func _on_attacking_die_roller_roll_results_ready(passed, number_rolled):
	print("DIE RESULTS READY")
	if passed == true:
		#TEMPORARY CODE UNTIL ARM CONNECTION IS MADE
		opponent.curr_health -= 1
		refresh_temp_labels()
	curr_turn = TURN.ENEMY
#endregion
