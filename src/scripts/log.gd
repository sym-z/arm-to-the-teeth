extends Node

signal new_log

var log_messages : Array[String] = []
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func add_log_message(msg : String):
	log_messages.append(msg)
	new_log.emit()
