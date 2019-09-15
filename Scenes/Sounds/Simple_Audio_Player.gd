extends Node2D
## Audio Player

onready var audio_player_object = get_node("AudioStreamPlayer2D")
var audio_test_file = preload ("res://Assets/Sounds/Effects/scream_woman2.wav")

	
func play_audio (audio_file):
	audio_player_object = get_node("AudioStreamPlayer2D")
	audio_player_object.stream = audio_file
	audio_player_object.play()


func play_test_sound ():
	print ("playing test sound")
	audio_player_object.stream = audio_test_file
	audio_player_object.play ()