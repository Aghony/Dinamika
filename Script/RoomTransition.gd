extends Node

var target_spawn: String = ""

func change_room(scene_path: String, spawn_name: String) -> void:
	target_spawn = spawn_name
	get_tree().change_scene_to_file(scene_path)
