extends Node2D

export (PackedScene) var Pickup

func _on_Area2D_body_entered(body):
	print(body.get_children())
	for b in body.get_children():
		if b.get_name() == "Weapon":
			body.remove_child(b)

	var b = Pickup.instance()
	b.set_name("Weapon")
	body.add_child(b)
	
	body.full_health()
