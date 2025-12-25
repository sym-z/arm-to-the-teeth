extends Node
@export_category("Speakers")
@export var base_speaker : AudioStreamPlayer
@export var sting_speaker : AudioStreamPlayer
@export_category("Sting Settings")
@export var sting_timer : Timer
@export var max_sting_interval : float = 5.0
@export var min_sting_interval : float = 0.25

var noise_base : AudioStreamMP3 = preload("uid://bivk4oj8li1mu")

### Stings
var sting_arr : Array[AudioStreamMP3] = []
# Groans
var groan_0 : AudioStreamMP3 = preload("uid://c1veis6jpm07a")
var groan_1 : AudioStreamMP3 = preload("uid://bex4jgmnc0s16")
var groan_2 : AudioStreamMP3 = preload("uid://bt0c21v8qus4h")
var groan_3 : AudioStreamMP3 = preload("uid://roin5srstl0r")
var groan_4 : AudioStreamMP3 = preload("uid://brf86vawkwrqd")


func _ready():
	load_stings()
	play_base()
	start_sting_chain()
	
func play_base():
	base_speaker.stream = noise_base
	base_speaker.play()
	
	
#region Stings
func load_stings():
	sting_arr = [groan_0,groan_1,groan_2,groan_3,groan_4]
	
func play_random_sting():
	var random_index = randi_range(0,sting_arr.size()-1)
	sting_speaker.stream = sting_arr[random_index]
	sting_speaker.pitch_scale = randf_range(0.8,1.0)
	sting_speaker.play()
	
func start_sting_chain():
	sting_timer.connect("timeout", play_random_sting)
	sting_speaker.connect("finished", reset_sting_timer)
	sting_timer.wait_time = randf_range(min_sting_interval,max_sting_interval)
	sting_timer.start()
	
func reset_sting_timer():
	sting_timer.wait_time = randf_range(min_sting_interval,max_sting_interval)
	sting_timer.start()
	
func set_mute(mute: bool):
	print("CALLED WITH ", mute)
	if mute == true:
		base_speaker.volume_db = -80.0
		sting_speaker.volume_db = -80.0
	else:
		base_speaker.volume_db = 0.0
		sting_speaker.volume_db = 0.0
#endregion
