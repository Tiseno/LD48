extends KinematicBody2D

const GRAVITY = 3000;
const FRICTION = 10000;
const WALL_FRICTION = 2000;

var ACCELERATION = Vector2(3000.0, 1000.0)
var AIR_ACCELERATION_FACTOR = 1
var ACCELERATION_MAX_X = 1000.0

var JUMP_POWER = 800.0
var JUMP_DIMINISH_FACTOR = 0.92
var JUMP_COOLDOWN = 0.3
var JUMP_NO_JUMP_THRESHOLD = 450

var jumpTimer = 0.0

var lastWall = Vector2(0.0, 0.0) # every same wall hit reduces jump power, and every other wall, ceiling, or floor resets jump power
var jumpPower = JUMP_POWER
var velocity = Vector2.ZERO
var aimDirection = Vector2(1.0, 0.0)

var dead = false


func _input(event):
	if dead:
		return
	if event is InputEventMouseMotion:
		var viewPort = get_viewport_rect().size
		aimDirection = (event.position - (viewPort/2)).normalized()
		var aim = get_node("Aim")
		aim.set_position(aimDirection * 20)
	if event is InputEventJoypadMotion:
		if event.axis == 2 or event.axis == 3:
			var joyDirection = Vector2(
				Input.get_action_strength("aim_right") - Input.get_action_strength("aim_left"),
				Input.get_action_strength("aim_down") - Input.get_action_strength("aim_up"))
			if not (joyDirection.x == 0.0 and joyDirection.y == 0.0):
				aimDirection = joyDirection.normalized()
				$Aim.set_position(aimDirection * 20)
			else:
				$Aim.set_position(Vector2(0.0, 0.0))


func weaponInput(delta: float):
	if Input.get_action_strength("shoot") != 0.0:
		var justPressed = Input.is_action_just_pressed("shoot")
		if get_node_or_null("Weapon"):
			$Weapon.shoot(aimDirection, justPressed)
	if Input.get_action_strength("shoot2") != 0.0:
		var justPressed = Input.is_action_just_pressed("shoot")
		if get_node_or_null("Weapon2"):
			$Weapon2.shoot(aimDirection, justPressed)


func kill():
	get_parent().game_over()
	dead = true

func applyFriction(delta):
	if is_on_floor():
		
		var deltaFriction = FRICTION * delta
		if (Input.get_action_strength("move_right") - Input.get_action_strength("move_left")) == 0.0:
			if(velocity.x > 0):
				if(velocity.x - deltaFriction < 0):
					velocity.x = 0
				else:
					velocity.x += -deltaFriction
			elif(velocity.x < 0):
				if(velocity.x + deltaFriction > 0):
					velocity.x = 0
				else:
					velocity.x += deltaFriction
		else:
			var moveDirection = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
			if moveDirection > 0 and velocity.x < 0:
				velocity.x += deltaFriction
			elif moveDirection < 0 and velocity.x > 0:
				velocity.x += -deltaFriction

	if is_on_wall():
		if velocity.y > 0:
			velocity.y += -WALL_FRICTION * delta


func move(delta):
	var accelerationDirection = Vector2(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
		-Input.get_action_strength("jump") + Input.get_action_strength("down"))
	accelerationDirection = accelerationDirection.normalized()
	var currentAcceleration = ACCELERATION
	if not is_on_floor():
		currentAcceleration.x = ACCELERATION.x * AIR_ACCELERATION_FACTOR
	var acceleration = currentAcceleration * accelerationDirection * delta

	var newVelocity = velocity
	if(newVelocity.x < ACCELERATION_MAX_X or newVelocity.x > -ACCELERATION_MAX_X):
		if(newVelocity.x + acceleration.x > ACCELERATION_MAX_X):
			newVelocity.x = ACCELERATION_MAX_X
		elif(newVelocity.x + acceleration.x < -ACCELERATION_MAX_X):
			newVelocity.x = -ACCELERATION_MAX_X
		else:
			newVelocity.x += acceleration.x
	
	newVelocity.y += acceleration.y
	return newVelocity


func performJump(delta):
	if is_on_wall():
		var lastWallTemp
		for i in get_slide_count():
			var collision = get_slide_collision(i)
			if collision.normal.x != lastWall.x:
				jumpPower = JUMP_POWER
			lastWallTemp = collision.normal
		lastWall = lastWallTemp
	if is_on_floor() or is_on_ceiling():
		jumpPower = JUMP_POWER
	var newVelocity = velocity
	jumpTimer += delta
	if (is_on_floor() or is_on_wall()) and Input.get_action_strength("jump") != 0.0 and jumpTimer > JUMP_COOLDOWN and jumpPower > JUMP_NO_JUMP_THRESHOLD:
		jumpTimer = 0
		newVelocity.y = -jumpPower
		if(is_on_wall()):
			for i in get_slide_count():
				var collision = get_slide_collision(i)
				newVelocity.x = collision.normal.x * (jumpPower / 3)
		jumpPower = jumpPower * JUMP_DIMINISH_FACTOR
	return newVelocity


func _physics_process(delta: float) -> void:
	applyFriction(delta)
	if not dead:
		weaponInput(delta)
		velocity = move(delta)
		velocity = performJump(delta)
	velocity.y += GRAVITY * delta
	velocity = move_and_slide(velocity, Vector2.UP)
