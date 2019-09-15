extends Particles2D

func _ready():
	pass

func start_timer():
	$Timer.start()

func _on_Timer_timeout():
	var state = get_node("/root/GameState")
	state.is_game_over = true
	state.game_over_state = state.game_over.KILLED
