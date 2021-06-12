extends Control


onready var saves_list := $VBoxContainer/ScrollContainer/SavesList

var load_save_packed = preload("res://ui/custom_widgets/LoadSaveButton.tscn")



func _ready() -> void:
	# Replace with loop finding every save file in save folder later
	for i in range(25):
		new_save("Save #%s" % [i])



func load_file(file_name: String) -> void:
	print("Load ", file_name)
	# Call level manager to load specific level, and also save file
	# contents to global variable.



func new_save(file_name: String) -> void:
	var button : Button = load_save_packed.instance()
	
	button.anchor_right = 1.0
	button.text = file_name
	button.file = file_name
	
	button.connect("load_file", self, "load_file")
	
	saves_list.add_child(button)
