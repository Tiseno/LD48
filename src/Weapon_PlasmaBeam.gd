extends "res://src/Weapon.gd"



# Called when the node enters the scene tree for the first time.
func _ready():
	COOLDOWN = 0.3
	cooldownTimer = COOLDOWN


func weaponEffect(aimDirection: Vector2):
	$SoundShoot.play()
