extends CharacterBody2D

func move_towards_angle(current: float, target: float, delta: float) -> float:
	var diff = wrapf(target - current, -PI, PI)
	if abs(diff) < delta:
		return target
	return current + sign(diff) * delta

func _physics_process(delta: float) -> void:
	velocity.y += 400. * delta * (1 + sin(velocity.angle()) ** 2) / 2
	var l = velocity.length()
	var a = velocity.angle()
	var target_x = Input.get_action_raw_strength("move_right") - Input.get_action_raw_strength("move_left")
	var target_y = Input.get_action_raw_strength("move_down") - Input.get_action_raw_strength("move_up")
	var target_angle = Vector2(target_x, target_y).angle()
	print(target_angle)
	if (Vector2(target_x, target_y).length() > .3):
		a = move_towards_angle(a, target_angle, 5. * delta)
	#if (Input.get_action_strength("move_right") > 0):
	#	a -= 5. * delta
	#if (Input.get_action_strength("move_left") > 0):
	#	a += 5. * delta
	velocity.x = l * cos(a)
	velocity.y = l * sin(a)
	rotation = a + PI / 2
	move_and_slide()
