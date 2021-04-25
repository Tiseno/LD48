extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func shoot(aimDirection: Vector2):
	print("Shoot base weapon")
	$SoundShoot.play()
	
func shoot_special(aimDirection: Vector2):
	print("Shoot special base weapon")
	$SoundShootSpecial.play()
	
