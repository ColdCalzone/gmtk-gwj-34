extends TextureButton
class_name SelectLevelButton


onready var beat_texture := preload("res://assets/ui/level_button_beat.png")
onready var unbeat_texture := preload("res://assets/ui/level_button_unbeat.png")
onready var display_level_label := $Label

export var beat := false

export(int) var level := 0

signal level_selected(level)



func _ready() -> void:
	display_level_label.text = str(level)
	update_beat()



func update_beat() -> void:
	var new_texture := unbeat_texture
	var new_text_color := Color("679d52")
	
	if beat:
		new_texture = beat_texture
		new_text_color = Color("181818")
	
	texture_normal = new_texture
	texture_pressed = new_texture
	texture_hover = new_texture
	texture_disabled = new_texture
	texture_focused = new_texture
	
	display_level_label.set("custom_colors/font_color", new_text_color)



func _on_LevelSelectButton_pressed() -> void:
	emit_signal("level_selected", level)
