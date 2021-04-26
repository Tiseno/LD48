extends Area2D

func _ready():
	print("Area readu")

func _on_DetectRadius_body_entered(body):
	print("Area Enter")

func _on_DetectRadius_body_exited(body):
	print("Area Exirtt")

