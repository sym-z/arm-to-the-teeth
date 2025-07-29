extends Node

signal new_log

var log_messages : Array[String] = []

func add_log_message(msg : String):
	#TODO: Include index to give visual ordering to the player.
	log_messages.append(msg)
	new_log.emit()

func clear_log():
	log_messages.clear()
