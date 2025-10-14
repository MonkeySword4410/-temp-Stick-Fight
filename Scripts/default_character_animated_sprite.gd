extends CharacterBody2D


const speed = 4800.0
const jump_velocity = -800.0
const gravity = 1600

var jump = false
var jump_inst = false
var left = false
var left_inst = false
var right = false
var right_inst = false

var coyote_time = 0

func _physics_process(delta: float) -> void:
	jump = Input.is_action_pressed("W")
	jump_inst = Input.is_action_just_pressed("W")
	left = Input.is_action_pressed("A")
	left_inst = Input.is_action_just_pressed("A")
	right = Input.is_action_pressed("D")
	right_inst = Input.is_action_just_pressed("D")
	
	if is_on_floor() or is_on_wall():
		coyote_time = 0
	else:
		coyote_time += delta
	
	if not is_on_floor() and not is_on_wall():
		velocity.y += gravity * delta
		if right and not left:
			velocity.x += speed / 2 * delta
		elif left and not right:
			velocity.x -= speed / 2 * delta
		velocity.x *= 0.9
		if jump and coyote_time < 0.1:
			velocity.y = jump_velocity * 3/4
			if velocity.x == 0:
				if left:
					velocity.x = -speed * 1/4
				if right:
					velocity.x = speed * 1/4
			else:
				velocity.x = (abs(velocity.x) / velocity.x) * speed * 1/4
			if abs(velocity.x) < 1:
				velocity.x = 0

	elif not is_on_floor() and is_on_wall():
		if right and not left:
			velocity.x += speed / 2 * delta
		elif left and not right:
			velocity.x -= speed / 2 * delta
		if (right or left) and velocity.y > 0:
			velocity.y += gravity / 2 * delta
			if velocity.y > 200:
				velocity.y -= gravity / 2 * delta
		else:
			velocity.y += gravity * delta
		if jump_inst and (left or right):
			velocity.y = jump_velocity * 2/3
			coyote_time = 1
			if left:
				velocity.x = speed * 1/4
			if right:
				velocity.x = -speed * 1/4

	elif is_on_floor():
		if jump:
			velocity.y = jump_velocity
			coyote_time = 1
		if right and not left:
			velocity.x += speed * delta
		elif left and not right:
			velocity.x -= speed * delta
		velocity.x *= 0.9
		if abs(velocity.x) < 1:
			velocity.x = 0

	move_and_slide()
