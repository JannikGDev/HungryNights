extends KinematicBody2D

# Declare member variables here. Examples:
export var speed = 300

onready var anim: AnimationPlayer = get_node("AnimationPlayer")
onready var polygons: Node2D = get_node("polygons")
onready var skeleton: Node2D = get_node("Skeleton2D")
var move = Vector2()

var alive: bool = true
var attacking: bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	anim.play("idle")
	pass
	
func movement():
	var move = Vector2()
	
	
	
	move_and_collide(move)


func kill():
	if alive:
		alive = false
		anim.play("idle")
		rotation = 90
		return true
	else:
		return false

func _process(delta):
	
	if alive:
		pass
	

