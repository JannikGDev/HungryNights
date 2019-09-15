extends Node2D

# Declare member variables here.
var AudioManager = null
#var audio_node = null

# Called when the node enters the scene tree for the first time.
func _ready():
	AudioManager = load("res://Global/AudioManager.gd").new()
	
#	audio_node = get_node("../AudioStreamPlayer2D")
#
#	audio_node.connect("finished", self, "sound_finished")
#	audio_node.stop()
	
	create_sound("morning")

func create_sound(sound_name):
	if is_instance_valid(AudioManager):
		#audio_node.stream = audio_stream
#		var stream:AudioStream
#		stream = fix
#		audio_node.stream = fix
#		audio_node.play()
		AudioManager.play_sound(sound_name, false)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
