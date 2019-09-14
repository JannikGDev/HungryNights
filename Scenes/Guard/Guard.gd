extends KinematicBody2D

var current_way
var current_point
var move_vec = Vector2()
export var speed = 100

# Called when the node enters the scene tree for the first time.
func _ready():
	current_way = $Navigation2D.get_simple_path(global_position, $Navigation2D/NavigationPolygonInstance/EinePosition.global_position)
	print(current_way)
	current_point = 0
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _physics_process(delta):
	move_to_point(current_point)
	print(move_vec)
	move_and_collide(move_vec * delta)

func move_to_point(point):
	move_vec = current_way[point] - global_position
	move_vec = move_vec.normalized()
	move_vec*=speed
	
	if global_position.distance_to(current_way[point]) < 2:
		if current_point + 1 < current_way.size():
			current_point += 1
		else:
			move_vec = Vector2(0,0)