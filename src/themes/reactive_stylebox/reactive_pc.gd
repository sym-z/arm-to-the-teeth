extends PanelContainer

var default_box : StyleBoxFlat = preload("uid://bmhjew6b2j2f1")
var blink_box : StyleBoxFlat = preload("uid://k6nota2k7epg")
var hover_box : StyleBoxFlat = preload("uid://b53bkad2aybog")


enum STATE {BLINK, HOVER, DEFAULT}

var curr_state : STATE = STATE.DEFAULT

var blink_timer : Timer
var blink_duration : float = 1.0

func _ready():
	connect("mouse_entered", start_hover)
	connect("mouse_exited", end_hover)
	Log.connect("new_log", start_blink)
	initialize_blink_timer()
	
func initialize_blink_timer():
	blink_timer = Timer.new()
	blink_timer.one_shot = true
	blink_timer.wait_time = blink_duration
	blink_timer.autostart = false
	blink_timer.connect("timeout", end_blink)
	add_child(blink_timer)
	
func start_hover():
	add_theme_stylebox_override("panel", hover_box)
	curr_state = STATE.HOVER
	
func end_hover():
	curr_state = STATE.DEFAULT
	add_theme_stylebox_override("panel", default_box)

func _gui_input(event):
	if event is InputEventMouseMotion:
		start_hover()
		
func start_blink():
	add_theme_stylebox_override("panel", blink_box)
	curr_state = STATE.BLINK
	blink_timer.start()

func end_blink():
	if curr_state == STATE.BLINK:
		curr_state = STATE.DEFAULT
		add_theme_stylebox_override("panel", default_box)
