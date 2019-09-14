extends KinematicBody2D

# Declare member variables here. Examples:
const baseSpeed = 300

onready var anim: AnimationPlayer = get_node("AnimationPlayer")
onready var polygons: Node2D = get_node("polygons")
onready var skeleton: Node2D = get_node("Skeleton2D")
var move = Vector2()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _process(delta):
	
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
		
		
	move_and_collide(baseSpeed*move*delta)
		
