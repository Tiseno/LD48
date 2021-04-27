extends Area2D

var speed = 550

func _physics_process(delta):
	position += transform.x * speed * delta

func _on_Bubble_body_entered(body):
	if body.has_method("take_damage") and not body.dead:
		body.take_damage(10.0)
	if "dead" in body and body.dead:
		pass
	else:
		queue_free()
		hide()
