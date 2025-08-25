extends Node

#region Loading Banks
var arm_eat_bank : Dictionary[int, AudioStreamMP3] = {
	0 : preload("res://assets/audio/arm_eat/arm_eat_-01.mp3"),
	1 : preload("res://assets/audio/arm_eat/arm_eat_-02.mp3"),
	2 : preload("res://assets/audio/arm_eat/arm_eat_-03.mp3"),
	3 : preload("res://assets/audio/arm_eat/arm_eat_-04.mp3"),
	4 : preload("res://assets/audio/arm_eat/arm_eat_-05.mp3"),
	5 : preload("res://assets/audio/arm_eat/arm_eat_-06.mp3"),
	6 : preload("res://assets/audio/arm_eat/arm_eat_-07.mp3"),
	7 : preload("res://assets/audio/arm_eat/arm_eat_-08.mp3"),
	8 : preload("res://assets/audio/arm_eat/arm_eat_1_-01.mp3"),
	9 : preload("res://assets/audio/arm_eat/arm_eat_1_-02.mp3"),
	10 : preload("res://assets/audio/arm_eat/arm_eat_1_-03.mp3"),
	11 : preload("res://assets/audio/arm_eat/arm_eat_1_-04.mp3"),
	12 : preload("res://assets/audio/arm_eat/arm_eat_1_-05.mp3"),
	13 : preload("res://assets/audio/arm_eat/arm_eat_1_-06.mp3"),
	14 : preload("res://assets/audio/arm_eat/arm_eat_1_-07.mp3"),
	15 : preload("res://assets/audio/arm_eat/arm_eat_1_-08.mp3"),
	16 : preload("res://assets/audio/arm_eat/arm_eat_1_-09.mp3"),
	17 : preload("res://assets/audio/arm_eat/arm_eat_1_-10.mp3"),
	18 : preload("res://assets/audio/arm_eat/arm_eat_1_-11.mp3"),
}
var e_death_bank : Dictionary[int, AudioStreamMP3] = {
	0 : preload("res://assets/audio/e_death/e_death-01.mp3"),
	1 : preload("res://assets/audio/e_death/e_death-02.mp3"),
	2 : preload("res://assets/audio/e_death/e_death-03.mp3"),
	3 : preload("res://assets/audio/e_death/e_death-04.mp3"),
	4 : preload("res://assets/audio/e_death/e_death-05.mp3"),
	5 : preload("res://assets/audio/e_death/e_death-06.mp3"),
	6 : preload("res://assets/audio/e_death/e_death-07.mp3"),
	7 : preload("res://assets/audio/e_death/e_death-08.mp3"),
	8 : preload("res://assets/audio/e_death/e_death-09.mp3"),
	9 : preload("res://assets/audio/e_death/e_death-10.mp3"),
}
var e_hurt_bank : Dictionary[int, AudioStreamMP3] = {
	0 : preload("res://assets/audio/e_hurt/e_hurt-01.mp3"),
	1 : preload("res://assets/audio/e_hurt/e_hurt-02.mp3"),
	2 : preload("res://assets/audio/e_hurt/e_hurt-03.mp3"),
	3 : preload("res://assets/audio/e_hurt/e_hurt-04.mp3"),
	4 : preload("res://assets/audio/e_hurt/e_hurt-05.mp3"),
	5 : preload("res://assets/audio/e_hurt/e_hurt-06.mp3"),
}
var footstep_bank : Dictionary[int, AudioStreamMP3] = {
	0 : preload("res://assets/audio/footstep/footstep-01.mp3"),
	1 : preload("res://assets/audio/footstep/footstep-02.mp3"),
	2 : preload("res://assets/audio/footstep/footstep-03.mp3"),
	3 : preload("res://assets/audio/footstep/footstep-04.mp3"),
	4 : preload("res://assets/audio/footstep/footstep-05.mp3"),
	5 : preload("res://assets/audio/footstep/footstep-06.mp3"),
	6 : preload("res://assets/audio/footstep/footstep-07.mp3"),
	7 : preload("res://assets/audio/footstep/footstep-08.mp3"),
	8 : preload("res://assets/audio/footstep/footstep-09.mp3"),
	9 : preload("res://assets/audio/footstep/footstep-10.mp3"),
	10 : preload("res://assets/audio/footstep/footstep-11.mp3"),
	11 : preload("res://assets/audio/footstep/footstep-12.mp3"),
	12 : preload("res://assets/audio/footstep/footstep1-01.mp3"),
	13 : preload("res://assets/audio/footstep/footstep1-02.mp3"),
	14 : preload("res://assets/audio/footstep/footstep1-03.mp3"),
	15 : preload("res://assets/audio/footstep/footstep1-04.mp3"),
	16 : preload("res://assets/audio/footstep/footstep1-05.mp3"),
	17 : preload("res://assets/audio/footstep/footstep1-06.mp3"),
	18 : preload("res://assets/audio/footstep/footstep1-07.mp3"),
	19 : preload("res://assets/audio/footstep/footstep1-08.mp3"),
	20 : preload("res://assets/audio/footstep/footstep1-09.mp3"),
	21 : preload("res://assets/audio/footstep/footstep1-10.mp3"),
	22 : preload("res://assets/audio/footstep/footstep1-11.mp3"),
}
var gate_bank : Dictionary[int, AudioStreamMP3] = {
	0 : preload("res://assets/audio/gate/gate-01.mp3"),
	1 : preload("res://assets/audio/gate/gate-02.mp3"),
	2 : preload("res://assets/audio/gate/gate-03.mp3"),
	3 : preload("res://assets/audio/gate/gate-04.mp3"),
	4 : preload("res://assets/audio/gate/gate-05.mp3"),
	5 : preload("res://assets/audio/gate/gate-06.mp3"),
	6 : preload("res://assets/audio/gate/gate-07.mp3"),
	7 : preload("res://assets/audio/gate/gate-08.mp3"),
	8 : preload("res://assets/audio/gate/gate-09.mp3"),
}
var p_hurt_bank : Dictionary[int, AudioStreamMP3] = {
	0 : preload("res://assets/audio/p_hurt/p_hurt-01.mp3"),
	1 : preload("res://assets/audio/p_hurt/p_hurt-02.mp3"),
	2 : preload("res://assets/audio/p_hurt/p_hurt-03.mp3"),
	3 : preload("res://assets/audio/p_hurt/p_hurt-04.mp3"),
	4 : preload("res://assets/audio/p_hurt/p_hurt-05.mp3"),
	5 : preload("res://assets/audio/p_hurt/p_hurt-06.mp3"),
	6 : preload("res://assets/audio/p_hurt/p_hurt-07.mp3"),
	7 : preload("res://assets/audio/p_hurt/p_hurt-08.mp3"),
	8 : preload("res://assets/audio/p_hurt/p_hurt-09.mp3"),
	9 : preload("res://assets/audio/p_hurt/p_hurt-10.mp3"),
	10 : preload("res://assets/audio/p_hurt/p_hurt-11.mp3"),
	11 : preload("res://assets/audio/p_hurt/p_hurt1-01.mp3"),
	12 : preload("res://assets/audio/p_hurt/p_hurt1-02.mp3"),
	13 : preload("res://assets/audio/p_hurt/p_hurt1-03.mp3"),
	14 : preload("res://assets/audio/p_hurt/p_hurt1-04.mp3"),
	15 : preload("res://assets/audio/p_hurt/p_hurt1-05.mp3"),
	16 : preload("res://assets/audio/p_hurt/p_hurt1-06.mp3"),
	17 : preload("res://assets/audio/p_hurt/p_hurt1-07.mp3"),
	18 : preload("res://assets/audio/p_hurt/p_hurt1-08.mp3"),
	19 : preload("res://assets/audio/p_hurt/p_hurt1-09.mp3"),
	20 : preload("res://assets/audio/p_hurt/p_hurt1-10.mp3"),
	21 : preload("res://assets/audio/p_hurt/p_hurt1-11.mp3"),
	22 : preload("res://assets/audio/p_hurt/p_hurt1-12.mp3"),
}
var tooth_insert_bank : Dictionary[int, AudioStreamMP3] = {
	0 : preload("res://assets/audio/tooth_insert/tooth_insert-01.mp3"),
	1 : preload("res://assets/audio/tooth_insert/tooth_insert-02.mp3"),
	2 : preload("res://assets/audio/tooth_insert/tooth_insert-03.mp3"),
	3 : preload("res://assets/audio/tooth_insert/tooth_insert-04.mp3"),
	4 : preload("res://assets/audio/tooth_insert/tooth_insert-05.mp3"),
	5 : preload("res://assets/audio/tooth_insert/tooth_insert-06.mp3"),
	6 : preload("res://assets/audio/tooth_insert/tooth_insert-07.mp3"),
	7 : preload("res://assets/audio/tooth_insert/tooth_insert-08.mp3"),
	8 : preload("res://assets/audio/tooth_insert/tooth_insert-09.mp3"),
	9 : preload("res://assets/audio/tooth_insert/tooth_insert-10.mp3"),
	10 : preload("res://assets/audio/tooth_insert/tooth_insert-11.mp3"),
	11 : preload("res://assets/audio/tooth_insert/tooth_insert-12.mp3"),
	12 : preload("res://assets/audio/tooth_insert/tooth_insert-13.mp3"),
}
var arm_pickup_bank : Dictionary[int, AudioStreamMP3] = {
	0 : preload("res://assets/audio/arm_pickup/arm_pickup_0.mp3"),
}
var hunger_state_change_bank : Dictionary[int, AudioStreamMP3] = {
	0 : preload("res://assets/audio/hunger/hunger_0.mp3"),
	1 : preload("res://assets/audio/hunger/hunger_1.mp3"),
}
var hunger_damage_bank : Dictionary[int, AudioStreamMP3] = {
	0 : preload("res://assets/audio/hunger/hunger_pain_0.mp3"),
}
var p_attack_bank : Dictionary[int, AudioStreamMP3] = {
	0 : preload("res://assets/audio/p_attack/p_attack_0.mp3"),
}
var p_whiff_bank : Dictionary[int, AudioStreamMP3] = {
	0 : preload("res://assets/audio/p_attack/p_whiff_0.mp3"),
}
var p_crit_bank : Dictionary[int, AudioStreamMP3] = {
	0 : preload("res://assets/audio/p_attack/p_crit_0.mp3"),
}
var ui_select_bank : Dictionary[int, AudioStreamMP3] = {
	0 : preload("res://assets/audio/ui/ui-02.mp3"),
	1 : preload("res://assets/audio/ui/ui-03.mp3"),
	2 : preload("res://assets/audio/ui/ui-04.mp3"),
}
var ui_accept_bank : Dictionary[int, AudioStreamMP3] = {
	0 : preload("res://assets/audio/ui/ui-01.mp3"),
}
var arm_swallow_bank : Dictionary[int, AudioStreamMP3] = {
	0 : preload("res://assets/audio/arm_eat/full_eat_0.mp3"),
}
#endregion
enum BANK {ARM_EAT, E_DEATH, E_HURT, FOOTSTEP, GATE, P_HURT, TOOTH_INSERT, ARM_PICKUP, H_STATE, H_HURT, P_ATT, P_WHIFF, P_CRIT, UI_SEL, UI_ACC, ARM_SWALLOW}
var bank_arr : Array[Dictionary]

func _ready():
	build_bank_arr()

func build_bank_arr():
	# Appending banks in order of enum to allow them to be used as a parameter for the general function
	bank_arr.append(arm_eat_bank)
	bank_arr.append(e_death_bank)
	bank_arr.append(e_hurt_bank)
	bank_arr.append(footstep_bank)
	bank_arr.append(gate_bank)
	bank_arr.append(p_hurt_bank)
	bank_arr.append(tooth_insert_bank)
	bank_arr.append(arm_pickup_bank)
	bank_arr.append(hunger_state_change_bank)
	bank_arr.append(hunger_damage_bank)
	bank_arr.append(p_attack_bank)
	bank_arr.append(p_whiff_bank)
	bank_arr.append(p_crit_bank)
	bank_arr.append(ui_select_bank)
	bank_arr.append(ui_accept_bank)
	bank_arr.append(arm_swallow_bank)
	
# Plays a random sound from the given bank
func play_rand(speaker : AudioStreamPlayer, bank : BANK):
	var rand_index : int = randi_range(0, bank_arr[bank].keys().size()-1)
	speaker.stream = bank_arr[bank][rand_index]
	speaker.play()
