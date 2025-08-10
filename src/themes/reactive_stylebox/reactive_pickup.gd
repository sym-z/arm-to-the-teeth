extends Button
var default_box : StyleBoxFlat = preload("uid://bmhjew6b2j2f1")
var blink_box : StyleBoxFlat = preload("uid://k6nota2k7epg")


enum STATE {BLINK, DEFAULT}

var curr_state : STATE = STATE.DEFAULT


func start_blink():
	curr_state = STATE.BLINK
	add_theme_stylebox_override("normal", blink_box)

func end_blink():
	curr_state = STATE.DEFAULT
	add_theme_stylebox_override("normal", default_box)
