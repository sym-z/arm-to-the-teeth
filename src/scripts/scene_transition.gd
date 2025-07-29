extends Node

var testing_level_scene : String = "uid://sp88rewvevlj"

func testing_level():
	call_deferred("change_scene", testing_level_scene)

func change_scene(scene: String):
	get_tree().change_scene_to_file(scene)
