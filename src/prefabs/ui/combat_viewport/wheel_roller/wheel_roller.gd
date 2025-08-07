extends MarginContainer

@export_category("Animations")
@export var wheel : AnimatedSprite2D
@export var clicker : AnimatedSprite2D

@export_category("Labels")
@export var result_label : Label

@export_category("Buttons")
@export var stop_button : Button
var result_network : Dictionary[int,Callable] = {
	0 : crit,
	1 : whiff_heavy,
	2 : whiff_medium,
	3 : whiff_light,
	4 : hit_light,
	5 : hit_heavy,
	6 : hit_light,
	7 : miss,
	8 : miss,
	9 : miss,
	10 : miss,
	11 : miss,
	12 : miss,
	13 : miss,
	14 : hit_light,
	15 : hit_heavy,
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
	5 : "HEAVY HIT!",
	6 : "LIGHT HIT!",
	7 : "MISS",
	8 : "MISS",
	9 : "MISS",
	10 : "MISS",
	11 : "MISS",
	12 : "MISS",
	13 : "MISS",
	14 : "LIGHT HIT!",
	15 : "HEAVY HIT!",
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
	
func spin_wheel():
	# Set to random frame
	wheel.frame = randi_range(0,wheel.sprite_frames.get_frame_count("default")-1)
	change_label()
	wheel.play()

func stop_wheel():
	wheel.pause()
	result_network[wheel.frame].call()

func crit():
	print("CRIT")
func whiff_heavy():
	print("H WHIF")
func whiff_medium():
	print("M WHIF")
func whiff_light():
	print("L WHIF")
func hit_heavy():
	print("H HIT")
func hit_light():
	print("L HIT")
func miss():
	print("MISS")
