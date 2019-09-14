extends KinematicBody2D

var current_way
var current_point
var move_vec = Vector2()
export var speed = 100

onready var anim: AnimationPlayer = get_node("AnimationPlayer")
onready var polygons: Node2D = get_node("polygons")
onready var skeleton: Skeleton2D = get_node("Skeleton2D")

var attacking: bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	current_way = $Navigation2D.get_simple_path(global_position, $Navigation2D/NavigationPolygonInstance/EinePosition.global_position)
	current_point = 0
	anim.playback_speed = speed / 300.0
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _physics_process(delta):
	
	if !attacking:
		move_to_point(current_point)
		move_and_collide(move_vec * delta * abs(scale.x))
		
		if move_vec.length() == 0:
			anim.play("idle")
		else:
			anim.play("walk")
			if move_vec.x > 0:
				polygons.scale.x = abs(polygons.scale.x)
				skeleton.scale.x = abs(skeleton.scale.x)
			if move_vec.x < 0:
				polygons.scale.x = -abs(polygons.scale.x)
				skeleton.scale.x = -abs(skeleton.scale.x)
		
	if attacking:
		if !anim.is_playing():
			attacking = false

func start_attack():
	attacking = true
	anim.play("attack")

func move_to_point(point):
	move_vec = current_way[point] - global_position
	move_vec = move_vec.normalized()
	move_vec*=speed
	
	if global_position.distance_to(current_way[point]) < 2:
		if current_point + 1 < current_way.size():
			current_point += 1
		else:
			move_vec = Vector2(0,0)