#helper for multiple audio stream playback
extends AudioStreamPlayer2D

var sound_pool : Array = [
	preload("res://assets/sfx/shot1.ogg"),
	preload("res://assets/sfx/shot2.ogg"),
	preload("res://assets/sfx/shot3.ogg"),
	preload("res://assets/sfx/shot4.ogg"),
	preload("res://assets/sfx/shot5.ogg"),
	preload("res://assets/sfx/shot6.ogg"),
]

func play( from_position=0.0 ):
	if !playing:
		set_stream(sound_pool[randi() % sound_pool.size()])
		.play(from_position)
	else:
		var asp = self.duplicate(DUPLICATE_USE_INSTANCING)
		get_parent().add_child(asp)
		asp.set_stream(sound_pool[randi() % sound_pool.size()])
		asp.play()
		yield(asp, "finished")
		asp.queue_free()
