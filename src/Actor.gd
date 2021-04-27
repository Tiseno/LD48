extends KinematicBody2D

const GRAVITY = 3000;
const FRICTION = 10000;
const WALL_FRICTION = 2000;

var ACCELERATION = Vector2(1000.0, 1000.0)
var AIR_ACCELERATION_FACTOR = 1
var ACCELERATION_MAX_X = 800.0

var JUMP_POWER = 600.0
var JUMP_DIMINISH_FACTOR = 0.92
var JUMP_COOLDOWN = 0.3
var JUMP_NO_JUMP_THRESHOLD = 450
var hp = 5

var jumpTimer = 0.0

var lastWall = Vector2(0.0, 0.0) # every same wall hit reduces jump power, and every other wall, ceiling, or floor resets jump power
var jumpPower = JUMP_POWER
var velocity = Vector2.ZERO
var aimDirection = Vector2(1.0, 0.0)

var dead = false

var wantToJump = false
var wantToMoveLeft = false
var wantToMoveRight = false
var wantToShoot = false
var moveDirection = Vector2(0.0, 0.0)

onready var _animated_sprite = $AnimatedSprite
onready var _die_sound = $SoundDie

var player = null
var target = null

func _ready():
	connect("body_enter", self, "_body_entered")

func _body_entered(body):
	print(body.get_name())
	if body.get_name() == "Player":
		print("Detected player")
		playerCollision(body)

func playerCollision(body):
	pass

func weaponInput(delta: float):
	if wantToShoot:
		if get_node_or_null("Weapon"):
			$Weapon.shoot(aimDirection, false)

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

func applyFriction(delta):
	if is_on_floor():
		var deltaFriction = FRICTION * delta
		if dead or not wantToMoveLeft and not wantToMoveRight:
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
			if wantToMoveRight and velocity.x < 0:
				velocity.x += deltaFriction
			elif wantToMoveLeft and velocity.x > 0:
				velocity.x += -deltaFriction

	if is_on_wall():
		if velocity.y > 0:
			velocity.y += -WALL_FRICTION * delta


func move(delta):
	var accelerationDirection = Vector2(0.0, 0.0)
	if dead:
		pass
	elif wantToMoveLeft and not wantToMoveRight:
		accelerationDirection = Vector2(-1.0, 0.0)
	elif not wantToMoveLeft and wantToMoveRight:
		accelerationDirection = Vector2(1.0, 0.0)
	elif not wantToMoveLeft and not wantToMoveRight:
		accelerationDirection = Vector2(0.0, 0.0)
	elif moveDirection != Vector2(0.0, 0.0):
		accelerationDirection = moveDirection
		
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
	if (is_on_floor() or is_on_wall()) and wantToJump and jumpTimer > JUMP_COOLDOWN and jumpPower >= JUMP_NO_JUMP_THRESHOLD:
		jumpTimer = 0
		newVelocity.y = -jumpPower
		if(is_on_wall()):
			for i in get_slide_count():
				var collision = get_slide_collision(i)
				newVelocity.x = collision.normal.x * (jumpPower / 3)
		jumpPower = jumpPower * JUMP_DIMINISH_FACTOR
		wantToJump = false
	return newVelocity


func playerNearby():
	return player != null

func behavior(delta: float):
	pass

func animate():
	if dead:
		_animated_sprite.play("dead")
	elif not is_on_floor():
		_animated_sprite.play("jump")
	elif wantToMoveLeft and not wantToMoveRight:
		_animated_sprite.play("walk")
		_animated_sprite.set_flip_h(false)
	elif not wantToMoveLeft and wantToMoveRight:
		_animated_sprite.play("walk")
		_animated_sprite.set_flip_h(true)
	elif not wantToMoveLeft and not wantToMoveRight:
		_animated_sprite.play("stand")
		
func _physics_process(delta: float) -> void:
	if not dead and hp < 0.0:
		kill()

	applyFriction(delta)
	
	if not dead:
		behavior(delta)
		weaponInput(delta)
		velocity = move(delta)
		velocity = performJump(delta)
		
	velocity.y += GRAVITY * delta
	velocity = move_and_slide(velocity, Vector2.UP)
	animate()

func take_damage(amount):
	hp = hp - amount
	print(name, " took ", amount, " damage")
