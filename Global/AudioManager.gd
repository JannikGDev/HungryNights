extends Node

var audio_clips = {
	"scream_woman":preload("res://Assets/Sounds/Effects/morning.wav"),
	"scream_man":preload("res://Assets/Sounds/Effects/scream_man.wav"),
	"morning":preload("res://Assets/Sounds/Effects/scream_woman2.wav")
}

const SIMPLE_AUDIO_PLAYER_SCENE = preload("res://Scenes/Sounds/Simple_Audio_Player.tscn")
var created_audio = []


func play_sound(sound_name, loop_sound=false):
	print ("a2")
	if audio_clips.has(sound_name):
		print ("a3")
		var new_audio = SIMPLE_AUDIO_PLAYER_SCENE.instance()
		new_audio.should_loop = loop_sound
		
		add_child(new_audio)
		created_audio.append(new_audio)
		
		new_audio.play_sound(audio_clips[sound_name])

	else:
		print ("ERROR: cannot play sound that does not exist in audio_clips!")