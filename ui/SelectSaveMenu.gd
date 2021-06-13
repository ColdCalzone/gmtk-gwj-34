extends Control

class SortStringByNumber:
	static func sort_ascending(a : String, b : String):
		var a_int = int(a)
		var b_int = int(b)
		return a_int < b_int


onready var saves_list := $VBoxContainer/ScrollContainer/SavesList

var load_save_packed = preload("res://ui/custom_widgets/LoadSaveButton.tscn")
var save_count := 0

enum MODE {LOAD, DELETE}

var mode = MODE.LOAD

func _ready() -> void:
	var files := []
	var dir = Directory.new()
	dir.open("user://")
	
	if not dir.dir_exists("saves"):
		dir.make_dir("saves")
	
	dir.change_dir("user://saves/")
	
	dir.list_dir_begin()
	
	# This variable will hold the highest found number at the end of the save name
	var highest_old_save : int = 0
	
	while true:
		var file : String = dir.get_next()
		var number = int(file.split(".")[0])
		if number > highest_old_save:
			highest_old_save = number
		if file == "":
			break
		elif file[0] != ".":
			files.append(file.split(".")[0])
	save_count = get_highest_save_number() + 1
	
	dir.list_dir_end()
	
	files.sort_custom(SortStringByNumber, "sort_ascending")
	
	for file in files:
		new_save(file)


func get_highest_save_number() -> int:
	var dir = Directory.new()
	dir.open("user://")
	
	if not dir.dir_exists("saves"):
		dir.make_dir("saves")
	
	dir.change_dir("user://saves/")
	
	dir.list_dir_begin()
	
	var highest_old_save : int = 0
	while true:
		var file : String = dir.get_next()
		var number = int(file.split(".")[0])
		if number > highest_old_save:
			highest_old_save = number
		if file == "":
			break
	return highest_old_save


func load_file(file_name: String) -> void:
	match mode:
		MODE.LOAD:
			Global.load_from_file("user://saves/%s.json" % [file_name])
		MODE.DELETE:
			delete_save(file_name)



func new_save(file_name: String) -> void:
	var button : Button = load_save_packed.instance()
	
	button.anchor_right = 1.0
	button.text = file_name
	button.file = file_name
	
	button.connect("load_file", self, "load_file")
	saves_list.add_child(button)
	
	for thing in saves_list.get_children():
		thing.modulate = Color(1, 1, 1)

func delete_save(file_name : String) -> void:
	var dir : Directory = Directory.new()
	
	dir.remove("user://saves/%s.json" % [file_name])
	
	for button in saves_list.get_children():
		if button.text == file_name:
			saves_list.remove_child(button)
	
	save_count = get_highest_save_number() + 1


func _on_NewSaveButton_pressed() -> void:
	var file := File.new()
	var content := {
		"level": 0
	}
	
	file.open("user://saves/save%s.json" % [save_count], File.WRITE)
	
	file.store_string(to_json(content))
	
	new_save("save%s" % [save_count])
	
	save_count += 1
	mode = MODE.LOAD


func _on_DeleteSaveButton_pressed():
	if mode == MODE.DELETE:
		for button in saves_list.get_children():
			button.modulate = Color(1, 1, 1)
		mode = MODE.LOAD
	else:
		for button in saves_list.get_children():
			button.modulate = Color(1, 0, 0)
		mode = MODE.DELETE
