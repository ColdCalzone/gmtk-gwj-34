extends Node2D


const SOUNDS := {
	
}

var looped_sounds := []



func play_sound(sound_name: String, loop: bool, volume: float) -> AudioStreamPlayer:
	var sound: AudioStream = SOUNDS[sound_name]
	var audio_player := AudioStreamPlayer.new()
	
	audio_player.stream = sound
	audio_player.volume_db = linear2db(volume)
	
	add_child(audio_player)
	
	audio_player.play()
	audio_player.connect("finished", self, "_on_some_finished_audio")
	
	if loop:
		looped_sounds.append(audio_player)
	
	return audio_player



func play_sound2d(sound_name: String, loop: bool, volume: float, position_: Vector2) -> AudioStreamPlayer2D:
	var sound: AudioStream = SOUNDS[sound_name]
	var audio_player := AudioStreamPlayer2D.new()
	
	audio_player.stream = sound
	audio_player.position = position_
	audio_player.volume_db = linear2db(volume)
	
	add_child(audio_player)
	
	audio_player.play()
	audio_player.connect("finished", self, "_on_some_finished_audio")
	
	if loop:
		looped_sounds.append(audio_player)
	
	return audio_player



func _on_some_finished_audio() -> void:
	for sound in get_children():
		if sound in looped_sounds:
			sound.play()
		else:
			sound.queue_free()
