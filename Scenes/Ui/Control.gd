extends Control
	
func _physics_process(delta):
	$Attention.value = get_node("/root/GameState").attention
	$Control/Clock/Pointer.rotation = (fmod(get_node("/root/GameState").daytime, 12) * ( (2 * PI) / 12))