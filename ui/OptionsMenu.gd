extends Control

const CONFIG_PATH : String = "user://settings.cfg"

onready var fullscreen_icon = preload("res://assets/sprites/settings/fullscreen.png")
onready var unfullscreen_icon = preload("res://assets/sprites/settings/unfullscreen.png")

onready var sfx = $CenterContainer/VBoxContainer/SFX/SFX
onready var sfx_image = $CenterContainer/VBoxContainer/SFX/Sound
onready var mus = $CenterContainer/VBoxContainer/MUS/MUS
onready var mus_image = $CenterContainer/VBoxContainer/MUS/Sound
onready var fullscreen = $Fullscreen

var config : ConfigFile

## Yoinked from myself
# https://github.com/ColdCalzone/bread-bread-breadvolution/blob/main/game/scenes/Settings.gd

func _ready():
	load_config()

func load_config():
	config = ConfigFile.new()
	var err = config.load(CONFIG_PATH)
	if err == ERR_FILE_NOT_FOUND:
		err = config.save(CONFIG_PATH)
	if err == OK:
		sfx.value = config.get_value("sound", "sfx_volume", 100)
		mus.value = config.get_value("sound", "mus_volume", 80)
		fullscreen.icon = unfullscreen_icon if config.get_value("graphics", "fullscreen", false) else fullscreen_icon

func save_config():
	config.set_value("sound", "mus_volume", mus.value)
	config.set_value("sound", "sfx_volume", sfx.value)
	config.set_value("graphics", "fullscreen", fullscreen.pressed)
	config.save(CONFIG_PATH)

func _on_Fullscreen_pressed():
	var new_state = !OS.window_fullscreen
	if !new_state:
		OS.set_window_size(Vector2(1024, 600))
	OS.set_window_fullscreen(new_state)
	config.set_value("graphics", "fullscreen", new_state)
	fullscreen.icon = unfullscreen_icon if new_state else fullscreen_icon
	save_config()
	fullscreen.release_focus()


func _on_SFX_value_changed(value : float):
	config.set_value("sound", "sfx_volume", value)
	sfx_image.frame = [value == 0, value > 0 and value < 0.3, value >= 0.3 and value < 0.6, value >= 0.6 and value < 0.9, value >= 0.9].find(true)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), linear2db(value))
	save_config()
	sfx.release_focus()


func _on_MUS_value_changed(value : float):
	config.set_value("sound", "mus_volume", value)
	mus_image.frame = [value == 0, value > 0 and value < 0.3, value >= 0.3 and value < 0.6, value >= 0.6 and value < 0.9, value >= 0.9].find(true)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("MUS"), linear2db(value))
	save_config()
	sfx.release_focus()

