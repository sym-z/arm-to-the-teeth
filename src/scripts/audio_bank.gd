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
#endregion
enum BANK {ARM_EAT}
var bank_arr : Array[Dictionary]

func _ready():
	# Appending banks in order of enum to allow them to be used as a parameter for the general function
	bank_arr.append(arm_eat_bank)

# Plays a random sound from the given bank
func play_rand(speaker : AudioStreamPlayer, bank : BANK):
	var rand_index : int = randi_range(0, bank_arr[bank].keys().size()-1)
	speaker.stream = bank_arr[bank][rand_index]
	speaker.play()
