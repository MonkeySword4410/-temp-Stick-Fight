extends CharacterBody2D


const x_velocity = 4800.0
const jump_velocity = 800.0
const gravity = -1600

var coyote_time = 0
var jumps = 1

@onready var animation = $AnimatedSprite2D

func _physics_process(delta: float) -> void:
	
	print(jumps)
	
	if not is_on_wall() and not is_on_floor():
		coyote_time += delta
	elif is_on_wall() or is_on_floor():
		coyote_time = 0
		jumps = 1
	if coyote_time > 0.1:
		jumps = 0
	if Input.is_action_just_pressed("W_key") and not is_on_wall() and not is_on_floor():
		if jumps == 1:
			velocity.y = -jump_velocity
			if Input.is_action_pressed("A_key") and not Input.is_action_pressed("D_key"):
				velocity.x = -x_velocity * 1/4
			elif Input.is_action_pressed("D_key") and not Input.is_action_pressed("A_key"):
				velocity.x = x_velocity * 1/4
	#This is applying appropriate gravity depending on what the player is going
	if not is_on_floor():
		if is_on_wall() and velocity.y > 0 and (Input.is_action_pressed("A_key") or Input.is_action_pressed("D_key")):
			velocity.y -= gravity / 4 * delta
			if is_on_wall() and not is_on_floor() and Input.is_action_pressed("W_key"):
				if not Input.is_action_pressed("D_key") or not Input.is_action_pressed("A_key"):
					velocity.y = -jump_velocity * 3/4
					jumps = 0
					if Input.is_action_pressed("A_key") and not Input.is_action_pressed("D_key"):
						velocity.x = x_velocity / 2
					elif Input.is_action_pressed("D_key") and not Input.is_action_pressed("A_key"):
						velocity.x = -x_velocity / 2
			if velocity.y > 200:
				velocity.y += gravity / 2 * delta
		else:
			velocity.y -= gravity * delta
	#This is saying how to jmup depending on where and what the player is doing
	elif is_on_floor():
		if Input.is_action_just_pressed("W_key"):
			velocity.y = -jump_velocity
			jumps = 0
	
	#This is movement left and right
	if Input.is_action_pressed("D_key") or Input.is_action_pressed("A_key"):
		if is_on_floor():
			if Input.is_action_pressed("D_key") and not Input.is_action_pressed("A_key"):
				velocity.x += x_velocity * delta
			elif Input.is_action_pressed("A_key") and not Input.is_action_pressed("D_key"):
				velocity.x -= x_velocity * delta
		else:
			if Input.is_action_pressed("D_key") and not Input.is_action_pressed("A_key"):
				velocity.x += x_velocity * 3/4 * delta
			elif Input.is_action_pressed("A_key") and not Input.is_action_pressed("D_key"):
				velocity.x -= x_velocity * 3/4 * delta
	velocity.x *= 0.9
	
	

	move_and_slide()
