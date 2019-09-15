extends Control

func _process(delta):
	var state = get_node("/root/GameState")
	
	if state.is_game_over:
		if state.game_over_state == state.game_over.KILLED:
			$TypicalGameOver.visible = true
			$LotGameOvrer.visible = false
		if state.game_over_state == state.game_over.BURNBYLO:
			$TypicalGameOver.visible = false
			$LotGameOvrer.visible = true
		if Input.is_action_pressed("ui_accept"):
			get_tree().quit()