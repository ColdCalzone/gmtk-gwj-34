extends Control


onready var tween := $GeneralTween
onready var main_container := $LeftPanel/MainContainer
onready var popups := $Popups
onready var options_container := $Popups/OptionsContainer
onready var left_panel := $LeftPanel
onready var pause_back := $PauseBack



func open_menu() -> void:
	show()
	
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
	
	hide()



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
