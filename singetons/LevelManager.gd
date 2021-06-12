extends Node2D


var levels := {
	0: {
		"scene": preload("res://scenes/Game.tscn"),
		"background": preload("res://icon.png"),
		"music": ""
	}
}



func load_level(level_num: int) -> void:
	var scene : PackedScene = levels[level_num]["scene"]
	var background : StreamTexture = levels[level_num]["background"]
	
	get_tree().change_scene_to(scene)
	
	# Set up parallax background stuff later, after gmtk
