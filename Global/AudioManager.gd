extends Node

var audio_player_scene = preload("res://Scenes/Sounds/Simple_Audio_Player.tscn")
#onready var audio_player_instance = audio_player_scene.instance ()

var audio_file_dict = {
	"scream_woman":preload ("res://Assets/Sounds/Effects/scream_woman.wav"),
	"scream_woman2":preload ("res://Assets/Sounds/Effects/scream_woman2.wav"),
	"morning":preload ("res://Assets/Sounds/Effects/morning.wav"),
	"scream_man":preload ("res://Assets/Sounds/Effects/scream_man.wav"),
	"death":preload ("res://Assets/Sounds/Effects/death.wav"),
	"day":preload ("res://Assets/Sounds/Ambience/day.wav"),
	"night":preload ("res://Assets/Sounds/Ambience/night.wav"),
	"owl":preload ("res://Assets/Sounds/Ambience/owl.wav")
	}

func play_audio_file (audio_file_name):
	 ###'scream_woman', 'scream_woman2', 'morning', 'scream_man', 'ambient5'###
	
	if !audio_file_dict.has (audio_file_name):
		print ("WARNING: Sound " + audio_file_name + " not found." )
		return
	
	var audio_file = audio_file_dict[audio_file_name]
	
	var audio_player_instance = audio_player_scene.instance ()
	add_child(audio_player_instance)
	#audio_player_instance.play_test_sound()
	audio_player_instance.play_audio(audio_file)
	
func stop_all_audio ():
    for N in self.get_children():
        remove_child(N)
	
	
	
