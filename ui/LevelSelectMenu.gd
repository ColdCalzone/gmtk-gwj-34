extends Control


onready var levels := {
	1: $LevelSelectButton1,
	2: $LevelSelectButton2,
	3: $LevelSelectButton3
}



func _ready() -> void:
	var beaten_levels : int = Global.get_data("level") - 1
	
	for level_num in levels.keys():
		if level_num <= beaten_levels:
			var level : SelectLevelButton = levels.get(level_num)
			
			level.beat = true
			level.update_beat()


func _select_level(level: int) -> void:
	LevelManager.load_level(level)
