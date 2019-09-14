extends Node2D

var audio_node = null
var should_loop = false
var globals = null
var initialized = false

#var fix = preload("res://Assets/Sounds/Ambience/cantina.wav")
var fix = preload("res://Assets/Sounds/Effects/scream_woman2.wav")


func _ready():
	initialized = true
	audio_node = get_node("AudioStreamPlayer2D")
	audio_node.connect("finished", self, "sound_finished")
	audio_node.stop()
	audio_node.stream = fix
	audio_node.play ()

	globals = load("res://Global/AudioManager.gd").new()
	#globals = get_node("Global/AudioManager")

func play_sound(audio_stream):
	if !initialized:
		_ready()

	if audio_stream == null:
		print ("No audio stream passed; cannot play sound")
		globals.created_audio.remove(globals.created_audio.find(self))
		queue_free()
		return

	#audio_node = get_node("AudioStreamPlayer2D")
	#audio_node.stream = audio_stream
	var stream:AudioStream
	stream = fix
	audio_node.stream = fix
	
	print (audio_node)
	print (is_instance_valid(audio_node))

	audio_node.play()

func sound_finished():
	if should_loop:
		audio_node.play()
	else:
		globals.created_audio.remove(globals.created_audio.find(self))
		audio_node.stop()
		queue_free()