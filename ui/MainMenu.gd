extends Control


onready var tween := $GeneralTween
onready var main_container := $LeftPanel/MainContainer
onready var popups := $Popups
onready var save_container := $Popups/SaveContainer
onready var options_container := $Popups/OptionsContainer



func _on_PlayButton_pressed() -> void:
	# Play pressed
	popups.show()
	save_container.show()
	
	tween.interpolate_property(popups, "modulate:a", 0.0, 1.0, 0.2)
	tween.start()



func _on_OptionsButton_pressed() -> void:
	# Options pressed
	popups.show()
	options_container.show()
	
	tween.interpolate_property(popups, "modulate:a", 0.0, 1.0, 0.2)
	tween.start()



func _on_QuitButton_pressed() -> void:
	# Quit pressed
	tween.interpolate_property(
		main_container, "rect_position:y", main_container.rect_position.y,
		main_container.rect_position.y + 16, 1
	)
	tween.interpolate_property(
		main_container, "modulate:a", main_container.modulate.a, 0, 0.8
	)
	tween.start()
	
	yield(tween, "tween_all_completed")
	
	get_tree().quit()



func _on_CloseButton_pressed() -> void:
	# Popup closed
	tween.interpolate_property(popups, "modulate:a", 1.0, 0.0, 0.2)
	tween.start()
	
	yield(tween, "tween_all_completed")
	
	popups.hide()
	save_container.hide()
	options_container.hide()
