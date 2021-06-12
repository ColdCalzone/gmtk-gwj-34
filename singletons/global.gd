extends Node


var save := {}
var save_file := ""

signal on_save
signal on_load



func set_data(data, value) -> void:
	save[data] = value



func get_data(data):
	return save[data]



func save_to_file() -> void:
	var file := File.new()
	
	file.open(save_file, File.WRITE)
	
	file.store_string(str(save))
	file.close()
	
	emit_signal("on_save")



func load_from_file(path: String) -> void:
	var file := File.new()
	
	file.open(path, File.READ)
	
	var content = file.get_as_text()
	
	file.close()
	
	save = JSON.parse(content).result
	save_file = path
	
	emit_signal("on_load")
