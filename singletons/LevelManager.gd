extends Node2D


var levels := {
	0: {
		"scene": preload("res://scenes/Game.tscn"),
		"background": preload("res://icon.png"),
		"music": ""
	}
}
var current_level := 0



func _ready() -> void:
	Global.subscribe(self)
	Global.connect("on_load", self, "on_load")



func _save_data() -> void:
	Global.set_data("level", current_level)



func on_load() -> void:
	load_level(Global.get_data("level"))



func load_level(level_num: int) -> void:
	var scene : PackedScene = levels[level_num]["scene"]
	var background : StreamTexture = levels[level_num]["background"]
	
	current_level = level_num
	
	get_tree().change_scene_to(scene)
	
	# Set up parallax background stuff later, after gmtk
