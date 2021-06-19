extends Control



func _select_level(level: int) -> void:
	LevelManager.load_level(level)
