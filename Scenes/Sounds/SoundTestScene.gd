extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	###'scream_woman', 'scream_woman2', 'morning', 'scream_man', 'ambient5'###
	get_node("/root/AudioManager").play_audio_file("scream_woman")
	get_node("/root/AudioManager").play_audio_file("scream_woman2")
	get_node("/root/AudioManager").play_audio_file("morning")
	get_node("/root/AudioManager").play_audio_file("night")
	
	var timer = Timer.new()
	timer.wait_time = 9.0
	timer.connect("timeout",self,"_on_timer_timeout") 
	#timeout is what says in docs, in signals
	#self is who respond to the callback
	#_on_timer_timeout is the callback, can have any name
	add_child(timer) #to process
	timer.start() #to start
	
	

func _on_timer_timeout():
   get_node("/root/AudioManager").stop_all_audio()
	
