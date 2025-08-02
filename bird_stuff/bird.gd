extends CharacterBody2D

@onready var chick_scene = preload("res://bird_stuff/chick.tscn")
#@onready var collision_polygon_2d: CollisionPolygon2D = $Area2D/CollisionPolygon2D

var num_positions
var previous_positions = []
var num_chicks = 30
var chick_interval = 5
var chicks = []

func _ready() -> void:
	num_positions = (num_chicks + 1) * chick_interval
	for i in range(num_positions):
		previous_positions.append(position)
	for i in range(num_chicks):
		var chick_cur = chick_scene.instantiate()
		chicks.append(chick_cur)
		add_sibling.call_deferred(chick_cur)
		chick_cur.position = position + 100. * Vector2.DOWN

func _process(delta: float) -> void:
	previous_positions.pop_back()
	previous_positions.push_front(position)
	for i in range(num_chicks):
		var c = chicks[i]
		c.position = previous_positions[chick_interval * (i + 1)]
		c.position.y += 15. * ((1 + i) ** .1) * sin(.005 * Time.get_ticks_msec() + .5 * i)
		var hash = i * 49824.4975
		hash = hash - int(hash)
		hash *= TAU
		c.position.y += 5. * sin(.02 * Time.get_ticks_msec() + hash)
	$Area2D/CollisionPolygon2D.polygon = []
	for i in range(num_chicks):
		for j in range(i + 5, num_chicks):
			if (chicks[j].position - chicks[i].position).length() < 40.:
				var polygon: PackedVector2Array = []
				for k in range(i, j - 1):
					polygon.append(to_local(chicks[k].position))
				$Area2D/CollisionPolygon2D.polygon = polygon

func move_towards_angle(current: float, target: float, delta: float) -> float:
	var diff = wrapf(target - current, -PI, PI)
	if abs(diff) < delta:
		return target
	return current + sign(diff) * delta

func _physics_process(delta: float) -> void:
	velocity.y += 600. * delta #* (1 + cos(velocity.angle()) ** 2) / 2
	var l = velocity.length()
	var a = velocity.angle()
	var target_x = Input.get_action_raw_strength("move_right") - Input.get_action_raw_strength("move_left")
	var target_y = Input.get_action_raw_strength("move_down") - Input.get_action_raw_strength("move_up")
	var target_angle = Vector2(target_x, target_y).angle()
	if (Vector2(target_x, target_y).length() > .3):
		a = move_towards_angle(a, target_angle, 4. * delta)
	'''
	var a_delta = 0
	if (Input.get_action_strength("move_right") > .3):
		a += 4. * delta
	if (Input.get_action_strength("move_left") > .3):
		a -= 4. * delta
	a += a_delta
	'''
	velocity.x = l * cos(a)
	velocity.y = l * sin(a)
	rotation = a + PI / 2
	move_and_slide()
