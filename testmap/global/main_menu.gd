extends AudioStreamPlayer

const level_music = preload("res://Songs/MAIN.mp3")

func _play_music(music: AudioStream, volume = 0.0):
	if stream == music:
		return
	
	stream = music
	volume_db = volume
	play()
	
func play_music_level():
	_play_music(level_music)
	
func stop_music():
	if is_playing():
		stop()
		
func restart_music():
	if is_playing():
		stop()
	play()
