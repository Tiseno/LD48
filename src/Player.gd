extends KinematicBody2D

const GRAVITY = 3000;
const FRICTION = 10000;
const WALL_FRICTION = 1000;

const PLAYER_ACCELERATION = Vector2(5000.0, 1000.0)
const AIR_ACCELERATION_FACTOR = 0.5

const PLAYER_ACCELERATION_MAX_SPEED = 1000.0

const JUMP_POWER = 800.0
const JUMP_DIMINISH_FACTOR = 0.92


var lastWall = Vector2(0.0, 0.0) # every same wall hit reduces jump power, and every other wall, ceiling, or floor resets jump power
var jumpPower = JUMP_POWER
var velocity = Vector2.ZERO
var aimDirection = Vector2(1.0, 0.0)


func _input(event):

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
			




func _ready():
	# Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	pass
	
func _physics_process(delta: float) -> void:
	
	if Input.is_action_just_pressed("shoot"):
		if get_node_or_null("Weapon"):
			$Weapon.shoot(aimDirection)
		else:
			print("was null")
			
	if Input.is_action_just_pressed("shoot_special"):
		if get_node_or_null("Weapon"):
			$Weapon.shoot_special(aimDirection)
		else:
			print("was null")
	
	var accelerationDirection = Vector2(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
		-Input.get_action_strength("jump") + Input.get_action_strength("down"))
	accelerationDirection = accelerationDirection.normalized()
	
	if is_on_floor() and accelerationDirection.x == 0.0:
		var deltaFriction = FRICTION * delta
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
				
	if is_on_wall():
		if velocity.y > 0:
			velocity.y += -WALL_FRICTION * delta
				
				
				
	var currentAcceleration = PLAYER_ACCELERATION
	if not is_on_floor():
		currentAcceleration.x = PLAYER_ACCELERATION.x * AIR_ACCELERATION_FACTOR
		
	var acceleration = currentAcceleration * accelerationDirection * delta
	
	if(velocity.x < PLAYER_ACCELERATION_MAX_SPEED or velocity.x > -PLAYER_ACCELERATION_MAX_SPEED):
		if(velocity.x + acceleration.x > PLAYER_ACCELERATION_MAX_SPEED):
			velocity.x = PLAYER_ACCELERATION_MAX_SPEED
		elif(velocity.x + acceleration.x < -PLAYER_ACCELERATION_MAX_SPEED):
			velocity.x = -PLAYER_ACCELERATION_MAX_SPEED
		else:
			velocity.x += acceleration.x
		
		
		
		
	velocity.y += acceleration.y + GRAVITY * delta
	
	
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
		
	 
	if (is_on_floor() or is_on_wall()) and Input.get_action_strength("jump") != 0.0:
		velocity.y = -jumpPower
		
		if(is_on_wall()):
			for i in get_slide_count():
				var collision = get_slide_collision(i)
				velocity.x = collision.normal.x * (jumpPower / 3)
				
		jumpPower = jumpPower * JUMP_DIMINISH_FACTOR
		
		
		
	
	velocity = move_and_slide(velocity, Vector2.UP)
	
	if Input.is_action_just_pressed("restart"):
		set_global_position(Vector2(0.0, 0.0))
	
