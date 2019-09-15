extends Node2D

const SmokeResource = preload("res://Scenes/Smoke/Smoke.tscn")

func _ready():
	pass

func _on_vampire_player_attacked():
	kill_player()

func _on_Area2D_body_entered(body):
	if body.get_name() == "Player":
		get_node("WorldEnvironment/HousesOutside").visible = false


func _on_Area2D_body_exited(body):
	if body.get_name() == "Player":
		get_node("WorldEnvironment/HousesOutside").visible = true

func _process(delta):
	var state = get_node("/root/GameState")
	if state.attention >= 100 && state.is_game_over == false:
		state.game_over_state = state.game_over.BURNBYLO
		state.is_game_over = true
		kill_player()
		
func kill_player():
	var smoke_instance = SmokeResource.instance()
	smoke_instance.emitting = true
	smoke_instance.global_position = $Player.global_position
	smoke_instance.start_timer()
	$Camera2D.global_position = $Player.global_position
	$Camera2D.current = true
	add_child(smoke_instance)