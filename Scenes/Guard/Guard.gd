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
onready var VisionCone: Sprite = get_node("VisionCone")
onready var spottedSprite: Sprite = get_node("Spotted")

var currentPatrole: int = 0

var attacking: bool = false
var spotting: bool = false


func findNearestPatrolePoint():
	var nearest = Vector2(-10000,-10000)
	var chosen: int = 0
	
	for i in range(12):
		var p = get_node("../PatrolNavigation/P"+str(i+1))
		
		if (p.global_position - self.global_position).length() < (nearest - self.global_position).length():
			nearest = p.global_position
			chosen = i
	
	return chosen

func _ready():
	currentPatrole = findNearestPatrolePoint()
	
	current_way = navigation.get_simple_path(global_position, get_node("../PatrolNavigation/P"+str(currentPatrole)).global_position)
	current_point_index = 0
	if len(current_way) == 0:
		current_way = [self.position]
	else:
		current_point = current_way[current_point_index]
		
	anim.playback_speed = speed / 300.0
	player_in_view = false

func _physics_process(delta):
	$ViewCone.rotation += (move_vec.angle() - $ViewCone.rotation) * delta
	VisionCone.rotation = move_vec.angle()
	
	spottedSprite.visible = player_in_view
	
	if !attacking:
		
		move_to_point(current_point, delta)
		collider = move_and_collide(move_vec * delta * abs(scale.x))
		
		if player_in_view:
			player_pos = player.global_position
			current_point = player_pos
			$PlayerChecker.cast_to = (player_pos - self.position)/self.scale
			if is_instance_valid($PlayerChecker.get_collider()) && $PlayerChecker.get_collider().name != "Player":
				player_in_view = false
		else:
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
	
	if (self.position - get_node("../PatrolNavigation/P"+str(currentPatrole)).global_position).length() <= speed*delta*10:
		currentPatrole = (currentPatrole%12)+1
		current_way = navigation.get_simple_path(global_position, get_node("../PatrolNavigation/P"+str(currentPatrole)).global_position)
		current_point_index = 0
		if len(current_way) == 0:
			current_way = [self.position]
		else:
			current_point = current_way[current_point_index]
		
	
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


func _on_Timer_timeout():
	player_in_view = spotting
		
