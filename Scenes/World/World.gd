extends Node2D

const SmokeResource = preload("res://Scenes/Smoke/Smoke.tscn")

func _ready():
	pass

func _on_vampire_player_attacked():
	var smoke_instance = SmokeResource.instance()
	smoke_instance.emitting = true
	smoke_instance.global_position = $Player.global_position
	$Camera2D.global_position = $Player.global_position
	$Camera2D.current = true
	add_child(smoke_instance)
	var state = get_node("/root/GameState")
	state.is_game_over = true
	state.game_over_state = state.game_over.KILLED


func _on_Area2D_body_entered(body):
	if body.get_name() == "Player":
		get_node("WorldEnvironment/HousesOutside").visible = false


func _on_Area2D_body_exited(body):
	if body.get_name() == "Player":
		get_node("WorldEnvironment/HousesOutside").visible = true