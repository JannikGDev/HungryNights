extends KinematicBody2D

# Declare member variables here. Examples:
export var speed = 50
export var female = false

onready var anim: AnimationPlayer = get_node("AnimationPlayer")
onready var polygons: Node2D = get_node("polygons")
onready var skeleton: Node2D = get_node("Skeleton2D")
onready var cone: Sprite = get_node("VisionCone")
onready var cone_collision: Area2D = get_node("Vision")
onready var spotted: Sprite = get_node("Spotted")

var alive: bool = true
var attacking: bool = false
var end_rotation: bool = false
var panic: bool = false

var currentTarget = 0

const randomRunLength = 600

var target: Vector2 = Vector2()



func findNearestPatrolePoint():
	var nearest = Vector2(-10000,-10000)
	var chosen: int = 0
	
	for i in range(12):
		var p = get_node("../PatrolNavigation/P"+str(i+1))
		
		if (p.global_position - self.global_position).length() < (nearest - self.global_position).length():
			nearest = p.global_position
			chosen = i
	
	return chosen

func clamp_vector(vec: Vector2, min_vec: Vector2, max_vec: Vector2):
	
	var result: Vector2 = Vector2()
	result.x = max(min(vec.x,max_vec.x), min_vec.x)
	result.y = max(min(vec.y,max_vec.y), min_vec.y)
	
	return result

# Called when the node enters the scene tree for the first time.
func _ready():
	anim.play("idle")
	currentTarget = findNearestPatrolePoint()
	target = get_node("../PatrolNavigation/P"+str(currentTarget)).global_position
	target = clamp_vector(target, Vector2(100, -1200), Vector2(1400, 500))
	
func movement(delta):
	var move = Vector2()
	
	if (target - self.position).length() < speed*delta*abs(scale.x)*5:
		currentTarget = (currentTarget%12)+1
		target = get_node("../PatrolNavigation/P"+str(currentTarget)).global_position
		target = clamp_vector(target, Vector2(100, -1200), Vector2(1400, 500))
		panic = false
	
	move = (target - self.position).normalized()
	
	cone.rotation = move.angle()
	cone_collision.rotation = move.angle()
	
	if move.x > 0:
		polygons.scale.x = 1
		skeleton.scale.x = 1
	elif move.x < 0:
		polygons.scale.x = -1
		skeleton.scale.x = -1
		
	if move.length() > 0:
		anim.play("walk")
	else:
		anim.play("idle")
		
		
	if panic:
		anim.playback_speed = speed*5 / 300.0
		move_and_collide(move*speed*delta*abs(scale.x)*5)
	else:
		anim.playback_speed = speed / 300.0
		move_and_collide(move*speed*delta*abs(scale.x))


func kill():
	if alive:
		alive = false
		if female:
			get_node("/root/AudioManager").play_audio_file("scream_woman2")
		else:
			get_node("/root/AudioManager").play_audio_file("scream_man")
		anim.play("idle")
		return true
	else:
		return false

func check_vision(delta):
	
	var spotted = cone_collision.get_overlapping_bodies()
	
	for entity in spotted:
		if entity.is_in_group("player"):
			panic = true
			target = self.position -(entity.position - self.position).normalized()*randomRunLength
			target = clamp_vector(target, Vector2(100, -1200), Vector2(1400, 500))

func _process(delta):
	
	if alive:
		movement(delta)
		
		check_vision(delta)
		
		spotted.visible = panic
		
	else:
		cone.visible = false
		spotted.visible = false
		
		if !end_rotation:
			set_rotation(get_rotation()+(PI/2 - get_rotation())*0.1)
			if (PI/2 - get_rotation()) < 0.01:
				end_rotation = true
	

