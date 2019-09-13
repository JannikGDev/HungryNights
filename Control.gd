extends Control

func set_time(time: float):
	$Clock/Pointer.rotate(time / 6 * PI)

func get_time():
	return ($Clock/Pointer.rotation / PI) * 6 
	
func set_attention(attention: float):
	$Attention.value = attention

func get_attention():
	return $Attention.value