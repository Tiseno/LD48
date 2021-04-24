extends KinematicBody2D
class_name Actor

export var gravity = 0;
export var speed = Vector2(300.0, 100.0)

var velocity = Vector2.ZERO

func _physics_process(delta):
	# velocity.y += gravity
	pass
