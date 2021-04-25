extends Node2D

var COOLDOWN = 0.1
var cooldownTimer = COOLDOWN

export (PackedScene) var Bullet

func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	cooldownTimer += delta

func shoot(aimDirection: Vector2, justPressed):
	if reloadPercent() >= 1.0:
		cooldownTimer = 0
		weaponEffect(aimDirection)
		
func reloadPercent():
	return min(cooldownTimer/COOLDOWN, 1.0)


func weaponEffect(aimDirection: Vector2):
	$SoundShoot.play()
	var b = Bullet.instance()
	add_child(b)
	b.transform.x = aimDirection
