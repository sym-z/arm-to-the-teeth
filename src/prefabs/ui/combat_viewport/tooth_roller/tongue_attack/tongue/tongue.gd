extends AnimatedSprite2D

var start_location : Marker2D
var flicker_location : Marker2D
var blockable : bool = false
var tween : Tween
var is_ready : bool = true
var retreat_time : float = 0.2
signal attack_done
signal creep_done
signal block_done
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
	tween.tween_property(self,"global_position", flicker_location.global_position, creep_time)
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
		tween.tween_property(self, "global_position", start_location.global_position, retreat_time)
		tween.tween_callback(block_cleanup)
		tween.play()
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
	global_position = start_location.global_position
	is_ready = true
