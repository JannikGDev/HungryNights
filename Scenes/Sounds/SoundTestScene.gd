extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	###'scream_woman', 'scream_woman2', 'morning', 'scream_man', 'ambient5'###
	get_node("/root/AudioManager").play_audio_file("scream_woman")
	get_node("/root/AudioManager").play_audio_file("scream_woman2")
	get_node("/root/AudioManager").play_audio_file("morning")
	get_node("/root/AudioManager").play_audio_file("scream_man")
	get_node("/root/AudioManager").play_audio_file("ambient5")
	
	
	
