extends Control

onready var tween = $Tween
onready var texture = $CenterContainer/TextureRect

var point : float = -1.0

func _ready():
	yield(get_tree().create_timer(0.75), "timeout")
	tween.interpolate_property(texture, "modulate:a", 0.0, 1.0, 1.0)
	tween.interpolate_property(texture, "modulate:a", 1.0, 0.0, 1.0, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, 1.0)
	tween.start()
	yield(tween, "tween_all_completed")
	get_tree().change_scene("res://ui/MainMenu.tscn")
