extends KinematicBody2D

var current_way
var current_point_index
var current_point: Vector2
var move_vec = Vector2()
var player_in_view: bool
export var speed = 100
export var traverse_back: bool = true

onready var anim: AnimationPlayer = get_node("AnimationPlayer")
onready var polygons: Node2D = get_node("polygons")
onready var skeleton: Skeleton2D = get_node("Skeleton2D")

var attacking: bool = false

func _ready():
	current_way = $Navigation2D.get_simple_path(global_position, $Navigation2D/NavigationPolygonInstance/EinePosition.global_position)
	current_point_index = 0
	current_point = current_way[current_point_index]
	anim.playback_speed = speed / 300.0
	player_in_view = false
	pass # Replace with function body.

func _physics_process(delta):
	$ViewCone.rotation += (move_vec.angle() - $ViewCone.rotation) * 0.8 * delta
	#$ViewCone.rotation = move_vec.angle()
	if !attacking:
		move_to_point(current_point, delta)
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

func move_to_point(point, delta):
	if global_position.distance_to(point) >= speed*delta:
		move_vec = point - global_position
		move_vec = move_vec.normalized()
		move_vec*=speed
	else:
		global_position = point
		if player_in_view:
			start_attack()
		else:
			next_waypoint()

func next_waypoint():
	if current_point_index + 1 < current_way.size():
		current_point_index += 1
		current_point = current_way[current_point_index]
	else:
		if traverse_back:
			current_way.invert()
			current_point_index = 0

func _on_ViewCone_body_entered(body):
	player_in_view = body.get_name() == "Player"

func _on_ViewCone_body_exited(body):
	if body.get_name() == "Player":
		player_in_view = false
