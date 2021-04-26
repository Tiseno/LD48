extends "res://src/Actor.gd"

var randomMovementTimer = 0.0
var randomMovementTime = 0.0

var randomJumpTimer = 0.0
var randomJumpTime = 0.0


func _ready():
	ACCELERATION = Vector2(2000.0, 1000.0)
	ACCELERATION_MAX_X = 3900.0
	JUMP_POWER = 1500.0
	JUMP_DIMINISH_FACTOR = 0.92
	JUMP_COOLDOWN = 0.3
	JUMP_NO_JUMP_THRESHOLD = 450
	randomJumpTime = 0.0 + randf()*1
	hp = 1 #00

func chasePlayer(delta: float):
	var playerDirection = player.get_global_position().direction_to(get_global_position())
	wantToJump = true
	if playerDirection.x > 0.0:
		wantToMoveLeft = true
		wantToMoveRight = false
	else:
		wantToMoveLeft = false
		wantToMoveRight = true

func randomMovement(delta: float):
	randomJumpTimer += delta
	if randomJumpTimer > randomJumpTime:
		randomJumpTime = 5.0 + randf()*5
		randomJumpTimer = 0.0
		wantToJump = true

	randomMovementTimer += delta
	if randomMovementTimer > randomMovementTime:
		randomMovementTime = 2.0 + randf()*2.0
		randomMovementTimer = 0.0
		var r = randf()
		if r < 0.4:
			wantToMoveLeft = true
			wantToMoveRight = false
		elif r > 0.4 and r < 0.8:
			wantToMoveLeft = false
			wantToMoveRight = true
		else:
			wantToMoveLeft = false
			wantToMoveRight = false

var attackTimer = 100

func behavior(delta: float):
	attackTimer += delta
	
	if target != null:
		if attackTimer > 0.2:
			attackTimer = 0.0
			target.take_damage(20)
	
	if playerNearby():
		ACCELERATION = Vector2(1000.0, 500.0)
		ACCELERATION_MAX_X = 1000
		JUMP_COOLDOWN = 1
		chasePlayer(delta)
	else:
		ACCELERATION = Vector2(400.0, 200.0)
		ACCELERATION_MAX_X = 100
		JUMP_COOLDOWN = 3
		randomMovement(delta)

func _on_PlayerDetector_body_entered(body):
	print("Darkbog detected player", body.get_name())
	player = body

func _on_PlayerDetector_body_exited(body):
	player = null

func _on_MeleeAttack_body_entered(body):
	target = body

func _on_MeleeAttack_body_exited(body):
	target = null

func kill():
	if dead:
		return
	dead = true
	wantToMoveLeft = false
	wantToMoveLeft = true
	wantToJump = false
	_animated_sprite.stop()
	_animated_sprite.play("dead")
	_die_sound.play()
	get_parent().victory()
