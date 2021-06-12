extends CanvasLayer


onready var pause_container := $PauseContainer
onready var tween := $PauseContainer/GeneralTween
onready var main_container := $PauseContainer/LeftPanel/MainContainer
onready var popups := $PauseContainer/Popups
onready var options_container := $PauseContainer/Popups/OptionsContainer
onready var left_panel := $PauseContainer/LeftPanel
onready var pause_back := $PauseContainer/PauseBack



func open_menu() -> void:
	pause_container.show()
	get_tree().paused = true
	
	tween.interpolate_property(pause_back, "modulate:a", 0.0, 1.0, 0.2)
	tween.interpolate_property(left_panel, "modulate:a", 0.0, 1.0, 0.4)
	tween.interpolate_property(left_panel, "rect_position:x", -16.0, 0.0, 0.4)
	tween.start()



func close_menu() -> void:
	tween.interpolate_property(pause_back, "modulate:a", 1.0, 0.0, 0.2)
	tween.interpolate_property(left_panel, "modulate:a", 1.0, 0.0, 0.4)
	tween.interpolate_property(left_panel, "rect_position:x", 0.0, -16.0, 0.4)
	tween.start()
	
	yield(tween, "tween_all_completed")
	
	pause_container.hide()
	get_tree().paused = false



func _on_ResumeButton_pressed() -> void:
	# Resume pressed
	close_menu()



func _on_SaveButton_pressed() -> void:
	# Save pressed
	pass



func _on_OptionsButton_pressed() -> void:
	# Options pressed
	popups.show()
	options_container.show()
	
	tween.interpolate_property(popups, "modulate:a", 0.0, 1.0, 0.2)
	tween.start()



func _on_MenuButton_pressed() -> void:
	# Main menu pressed
	pass



func _on_CloseButton_pressed() -> void:
	# Popup closed
	tween.interpolate_property(popups, "modulate:a", 1.0, 0.0, 0.2)
	tween.start()
	
	yield(tween, "tween_all_completed")
	
	popups.hide()
	options_container.hide()
