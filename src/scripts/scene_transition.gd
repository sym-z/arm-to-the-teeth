extends Node

var testing_level_scene : String = "uid://sp88rewvevlj"
var death_screen_scene : String = "uid://dwf7p0roh6mem"
var main_menu_scene : String = "uid://vedpap325i3n"
var tutorial_scene : String = "uid://b1pwicxgdt8l3"

func testing_level():
	call_deferred("change_scene", testing_level_scene)

func death_screen():
	call_deferred("change_scene", death_screen_scene)
	
func main_menu():
	call_deferred("change_scene", main_menu_scene)
	
func tutorial():
	call_deferred("change_scene", tutorial_scene)
	
func change_scene(scene: String):
	get_tree().change_scene_to_file(scene)
