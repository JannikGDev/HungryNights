extends KinematicBody2D

# Declare member variables here. Examples:
export var baseSpeed = 300
export var guardSpawnDis = 300
export var guardSpawnAmount = 3

onready var anim: AnimationPlayer = get_node("AnimationPlayer")
onready var polygons: Node2D = get_node("polygons")
onready var skeleton: Node2D = get_node("Skeleton2D")
onready var attackBox: Area2D = get_node("AttackBox")
onready var Guard = preload("res://Scenes/Guard/Guard.tscn")
var move = Vector2()

var attacking: bool = false

signal player_attacked

# Called when the node enters the scene tree for the first time.
func _ready():

	anim.playback_speed = baseSpeed / 300.0

	pass # Replace with function body.


func movement(delta):

	move = Vector2(0,0)

	if Input.is_action_pressed("move_down"):
		move += Vector2(0,1)

	if Input.is_action_pressed("move_up"):
		move += Vector2(0,-1)

	if Input.is_action_pressed("move_right"):
		move += Vector2(1,0)

	if Input.is_action_pressed("move_left"):
		move += Vector2(-1,0)

	if move.length() > 0:
		anim.play("walk")
	else:
		anim.play("idle")

	if move.x > 0:
		polygons.scale.x = 1
		skeleton.scale.x = 1
	elif move.x < 0:
		polygons.scale.x = -1
		skeleton.scale.x = -1

	move_and_collide(baseSpeed*move*delta*abs(scale.x))

func attackCheck(delta):
	if Input.is_action_just_pressed("attack") and !attacking:
		anim.play("attack")
		attacking = true

	if attacking and (anim.current_animation != "attack" or !anim.is_playing()):
		attacking = false

func _process(delta):
	if !attacking:
		movement(delta)

	attackCheck(delta)
	
	if get_node("/root/GameState").is_game_over:
		queue_free()
	
	if attacking:
		var victims = attackBox.get_overlapping_bodies()
		
		for entity in victims:
			if !entity.is_in_group("player") and entity.is_in_group("killable"):
				if entity.kill():
					var root: Node2D = get_parent()
					for i in range(0,guardSpawnAmount):
						var g: KinematicBody2D = Guard.instance()
						var offset: Vector2 = Vector2(guardSpawnDis,0)
						g.position = self.position + offset.rotated(randi()%360)
						g.position = clamp_vector(g.position, Vector2(400, -800), Vector2(1100, 300))
						g.z_index = 1
						g.scale = Vector2(0.35,0.35)
						g.speed = 100
						
						root.add_child(g)
						
			if !entity.is_in_group("player") and entity.is_in_group("guard"):
				entity.kill()

func attacked():
	get_node("/root/AudioManager").play_audio_file("death")
	emit_signal("player_attacked")
	queue_free()
	
func clamp_vector(vec: Vector2, min_vec: Vector2, max_vec: Vector2):
	
	var result: Vector2 = Vector2()
	result.x = max(min(vec.x,max_vec.x), min_vec.x)
	result.y = max(min(vec.y,max_vec.y), min_vec.y)
	
	return result