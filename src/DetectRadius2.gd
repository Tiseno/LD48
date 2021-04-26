extends CollisionShape2D

func _ready():
	print("CollisionShape2D readu")


func _on_DetectRadius_body_entered(body):
	print("CollisionShape2Denter")

func _on_DetectRadius_body_exited(body):
	print("CollisionShape2Dexit")

