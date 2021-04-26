extends Node2D

func _ready():
	$AnimationPlayer.play()

var player = null

var damageTimer = 100


func _physics_process(delta: float) -> void:
	damageTimer += delta
	if player == null:
		return
	if damageTimer > 0.1:
		damageTimer = 0
		player.take_damage(5)
	
func _on_Area2D_body_entered(body):
	player = body


func _on_Area2D_body_exited(body):
	player = null
