extends AnimatedSprite2D

var is_blocking = false
enum DIR{NONE=0,LEFT=1,DOWN=2,RIGHT=3}
var block_direction : DIR = DIR.NONE

@export var hurt_timer : Timer

var hurt_material = preload("uid://bqpmlo0tckkq4")

func _ready():
	connect("animation_finished", reset_animation)
	hurt_timer.connect("timeout", play_hurt_cleanup)
	material = null

func flick():
	unblock()
	animation = "flick"
	play()

func block_down():
	block_direction = DIR.DOWN
	rotation_degrees = 180
	block()
func block_left():
	block_direction = DIR.LEFT
	rotation_degrees = 270
	block()
func block_right():
	block_direction = DIR.RIGHT
	rotation_degrees = 90
	block()

func block():
	is_blocking = true
	animation = "block"
	play()
	
func unblock():
	block_direction = DIR.NONE
	is_blocking = false
	rotation_degrees = 0
	
func reset_animation():
	unblock()
	animation = "default"
	play()

func play_hurt():
	material = hurt_material
	hurt_timer.start()
	pass

func play_hurt_cleanup():
	material = null
	pass
