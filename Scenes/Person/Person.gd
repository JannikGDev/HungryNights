extends KinematicBody2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var anim: AnimationPlayer = get_node("AnimationPlayer")

# Called when the node enters the scene tree for the first time.
func _ready():
	anim.play("test")
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
