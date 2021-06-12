extends Button


var file: String

signal load_file


func _on_LoadSaveButton_pressed() -> void:
	emit_signal("load_file", file)
