extends AnimatedSprite2D

var start_location : Marker2D
var flicker_location : Marker2D
var blockable : bool = false
var tween : Tween
var is_ready : bool = true
var retreat_time : float = 0.1
signal attack_done
signal creep_done
signal block_done
@export var ending_scale : Vector2 = Vector2(1,1.25)
@export var start_scale : Vector2 = Vector2(1,0.5)


var mat = preload("uid://yb18qg4hd48n")
func _ready():
	visible = false
	play()
	connect("animation_finished", attack_cleanup)


func attack(attack_time : float):
	#print("IM ATTACKING")
	animation = "attack"
	play()
	blockable = false
	# TODO Apply damage?

func force_attack():
	if tween:
		tween.kill()
	animation = "attack"
	global_position = flicker_location.global_position
	play()
	blockable = false
	#TODO apply damage?

func attack_cleanup():
	if animation == "attack":
		animation = "default"
		reset()
		attack_done.emit()

func creep(creep_time : float):
	is_ready = false
	visible = true
	#TODO TWEEN
	if tween:
		#print("killing")
		tween.kill()
	tween = create_tween()
	tween.tween_property(self,"scale", ending_scale, creep_time)
	tween.tween_callback(creep_cleanup)
	blockable = true
	#print("CREEPING")
	
	#TODO: DO THIS IN TWEEN CALLBACK
	

func creep_cleanup():
	creep_done.emit()
	pass
func block():
	# TODO: Play block anim
	if blockable:
		if tween:
			tween.kill()
			
		tween = create_tween()
		tween.tween_property(self, "scale", start_scale, retreat_time)
		tween.tween_callback(block_cleanup)
		tween.play()
		material = null
		#print("BLOCKED")

func block_cleanup():
	block_done.emit()
	reset()
	
func reset():
	#print("RESETTING")
	animation = "default"
	play()
	blockable = false
	visible = false
	#global_position = start_location.global_position
	scale = start_scale
	is_ready = true
	material = mat


	
