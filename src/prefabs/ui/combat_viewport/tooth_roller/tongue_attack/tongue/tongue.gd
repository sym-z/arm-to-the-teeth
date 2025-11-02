extends AnimatedSprite2D

var start_location : Marker2D
var flicker_location : Marker2D
var blockable : bool = false
var tween : Tween

signal attack_done
signal creep_done
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func attack(attack_time : float):
	print("IM ATTACKING")
	blockable = false
	#TODO: Attack anim
	#TODO Tween
	#TODO: DO THESE IN TWEEN CALLBACK
	attack_done.emit()
	reset()
	pass

func creep(creep_time : float):
	visible = true
	#TODO TWEEN
	print("CREEPING")
	blockable = true
	#TODO: DO THIS IN TWEEN CALLBACK
	creep_done.emit()

func block():
	# Play block anim
	# TODO TWEEN
	print("BLOCKED")
	reset()
	
	#tween.kill()
	
func reset():
	print("RESETTING")
	blockable = false
	visible = false
	global_position = start_location.global_position
