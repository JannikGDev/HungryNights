extends StaticBody2D

var time

func _physics_process(delta):
	time = get_node("/root/GameState").daytime
	if time > 18 && time <= 24 || time >= 0 && time < 6:
		$Light2D.energy = 1
	else: 
		$Light2D.energy = 0