extends KinematicBody2D

# Declare member variables here. Examples:
export var speed = 300

onready var anim: AnimationPlayer = get_node("AnimationPlayer")
onready var polygons: Node2D = get_node("polygons")
onready var skeleton: Node2D = get_node("Skeleton2D")
var move = Vector2()

var attacking: bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	anim.play("walk")
	anim.playback_speed = speed / 300


func _process(delta):
	pass

