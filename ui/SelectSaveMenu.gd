extends Control


onready var saves_list := $VBoxContainer/ScrollContainer/SavesList

var load_save_packed = preload("res://ui/custom_widgets/LoadSaveButton.tscn")
var save_count := 0



func _ready() -> void:
	var files := []
	var dir = Directory.new()
	dir.open("user://")
	
	if not dir.dir_exists("saves"):
		dir.make_dir("saves")
	
	dir.change_dir("user://saves/")
	
	dir.list_dir_begin()
	
	while true:
		var file : String = dir.get_next()
		
		if file == "":
			break
		elif file[0] != ".":
			files.append(file.split(".")[0])
	
	dir.list_dir_end()
	
	
	
	for file in files:
		save_count += 1
		new_save(file)



func load_file(file_name: String) -> void:
	Global.load_from_file("user://saves/%s.json" % [file_name])



func new_save(file_name: String) -> void:
	var button : Button = load_save_packed.instance()
	
	button.anchor_right = 1.0
	button.text = file_name
	button.file = file_name
	
	button.connect("load_file", self, "load_file")
	
	saves_list.add_child(button)



func _on_NewSaveButton_pressed() -> void:
	var file := File.new()
	var content := {
		"level": 0
	}
	
	file.open("user://saves/save%s.json" % [save_count], File.WRITE)
	
	file.store_string(to_json(content))
	
	new_save("save%s" % [save_count])
