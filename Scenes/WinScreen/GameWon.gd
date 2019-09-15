extends Control

func _process(delta):
	var state = get_node("/root/GameState")
	
	if state.game_won:
		$GameWon.visible = true
		if Input.is_action_pressed("ui_accept"):
			get_tree().change_scene("res://StartScreen/StartScreen.tscn")
			