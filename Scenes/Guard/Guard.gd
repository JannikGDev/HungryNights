extends KinematicBody2D

var current_way
var current_point_index
var current_point: Vector2
var move_vec = Vector2()
var player_in_view: bool
var player_pos = Vector2()
var player
var collider
export var speed = 100
export var traverse_back: bool = true

onready var anim: AnimationPlayer = get_node("AnimationPlayer")
onready var polygons: Node2D = get_node("polygons")
onready var skeleton: Skeleton2D = get_node("Skeleton2D")
onready var navigation: Navigation2D = get_node("../PatrolNavigation")

var attacking: bool = false
var spotting: bool = false

func _ready():
	current_way = navigation.get_simple_path(global_position, get_node("../PatrolNavigation/PatrolePoint").global_position)
	current_point_index = 0
	current_point = current_way[current_point_index]
	anim.playback_speed = speed / 300.0
	player_in_view = false
	pass # Replace with function body.

func _physics_process(delta):
	$ViewCone.rotation += (move_vec.angle() - $ViewCone.rotation) * 0.9 * delta
	if !attacking:
		move_to_point(current_point, delta)
		collider = move_and_collide(move_vec * delta * abs(scale.x))
		
		if player_in_view:
			player_pos = player.global_position
			current_point = player_pos
			$PlayerChecker.rotation = get_angle_to(player_pos)
			#print("player is in view")
			#print(player.global_position)
			if $PlayerChecker.get_collider() != player:
				player_in_view = false
		else:
			#print("no player in view")
			current_point = current_way[current_point_index]
		
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
				
		
		if is_instance_valid(collider) && collider.get_collider().name == "Player":
			start_attack(collider.get_collider())
			
	if attacking:
		if !anim.is_playing():
			attacking = false
		

func start_attack(body):
	attacking = true
	body.attacked()
	anim.play("attack")

func move_to_point(point, delta):
	if global_position.distance_to(point) >= speed*delta:
		move_vec = point - global_position
		move_vec = move_vec.normalized()
		move_vec*=speed
	else:
		global_position = point
		if !player_in_view:
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
	if body.get_name() == "Player":
		player = body
		player_pos = body.global_position
		$Timer.start()
		spotting = true

func _on_ViewCone_body_exited(body):
	if body.get_name() == "Player":
		player_in_view = false
		spotting = false
		#print("exited")


func _on_Timer_timeout():
	player_in_view = spotting
		
