extends "res://src/Actor.gd"

var randomMovementTimer = 0.0
var randomMovementTime = 0.0

var randomJumpTimer = 0.0
var randomJumpTime = 0.0


func _ready():
	ACCELERATION = Vector2(1000.0, 1000.0)
	ACCELERATION_MAX_X = 300.0
	
	JUMP_POWER = 600.0
	JUMP_DIMINISH_FACTOR = 0.92
	JUMP_COOLDOWN = 0.3
	JUMP_NO_JUMP_THRESHOLD = 450
	randomJumpTime = 5.0 + randf()*5



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
			kill()
		elif r > 0.4 and r < 0.8:
			wantToMoveLeft = false
			wantToMoveRight = true
		else:
			$AnimatedSprite.play("stand")
			wantToMoveLeft = false
			wantToMoveRight = false

func behavior(delta: float):
	if dead:
		return
	if playerNearby():
		ACCELERATION = Vector2(500.0, 500.0)
	else:
		ACCELERATION = Vector2(400.0, 200.0)
		ACCELERATION_MAX_X = 100
		JUMP_COOLDOWN = 3
		randomMovement(delta)
