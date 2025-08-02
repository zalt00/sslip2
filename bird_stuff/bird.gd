extends CharacterBody2D

@onready var chick_scene = preload("res://bird_stuff/chick.tscn")
#@onready var collision_polygon_2d: CollisionPolygon2D = $Area2D/CollisionPolygon2D

class Chick:
	var node: Node2D
	var virtual_position: Vector2
	var interpolation_factor: float
	func _init(n, v, i):
		node = n
		virtual_position = v
		interpolation_factor = i

var num_positions
var previous_positions = []
var num_chicks = 31
var chick_interval = 5
var chicks: Array = []
var time_since_last_loop = 0
var dead = false

func _ready() -> void:
	$flaaaap2.play(1.5)
	$flaaaap3.play(2.5)

	num_positions = (num_chicks + 1) * chick_interval
	for i in range(num_positions):
		previous_positions.append(position)
	for i in range(num_chicks):
		var chick_cur = chick_scene.instantiate()
		chicks.append(Chick.new(chick_cur, Vector2.ZERO, 10.))
		add_sibling.call_deferred(chick_cur)
	chicks[-1].node.visible = false
func _process(delta: float) -> void:
	previous_positions.pop_back()
	previous_positions.push_front(position)
	if !dead:
		for i in range(num_chicks):
			chicks[i].virtual_position = previous_positions[chick_interval * (i + 1)]
			chicks[i].virtual_position.y += 15. * ((1 + i) ** .1) * sin(.005 * Time.get_ticks_msec() + .5 * i)
			var h = i * 49824.4975
			h = h - int(h)
			h *= TAU
			chicks[i].virtual_position.y += 5. * sin(.02 * Time.get_ticks_msec() + h)
	$Area2D/CollisionShape2D.shape.points = []
	time_since_last_loop += delta
	var loop_found = false
	
	if !dead:
		# LOOP DETECTION + KILL ANIMATION
		for i in range(num_chicks):
			for j in range(i + 5, num_chicks):
				if (chicks[j].node.position - chicks[i].node.position).length() < 40.:
					loop_found = true
					if time_since_last_loop >= 1.5 and (j-i + 1) > 10:
						if !$flap_small.is_playing() and (j-i + 1) > 15:
							$flap_small.pitch_scale = randf_range(0.9, 1.1)
							$flap_small.play()
						time_since_last_loop = 0.
						if (j - i + 1) % 2 == 1:
							--j
						for k in range(i, (i + j) / 2):
							var tmp = chicks[k].node.position
							chicks[k].interpolation_factor = 1.
							chicks[k + (j - i + 1) / 2].interpolation_factor = 1.
							chicks[k].node.position = chicks[k + (j - i + 1) / 2].node.position
							chicks[k + (j - i + 1) / 2].node.position = tmp
					var polygon: PackedVector2Array = []
					for k in range(i, j + 1):
						polygon.append(to_local(chicks[k].virtual_position))
					$Area2D/CollisionShape2D.shape.points = polygon
					break
			if loop_found:
				break
	for i in range(num_chicks):
		chicks[i].interpolation_factor = lerp(chicks[i].interpolation_factor, 10., 1. * delta)
		chicks[i].node.position = lerp(chicks[i].node.position, chicks[i].virtual_position, chicks[i].interpolation_factor * delta)

func move_towards_angle(current: float, target: float, delta: float) -> float:
	var diff = wrapf(target - current, -PI, PI)
	if abs(diff) < delta:

		return target
	return current + sign(diff) * delta

func _physics_process(delta: float) -> void:
	if dead:
		return
	velocity.y += 600. * delta #* (1 + cos(velocity.angle()) ** 2) / 2
	var l = velocity.length()
	var a = velocity.angle()
	
	var target_x = Input.get_action_raw_strength("move_right") - Input.get_action_raw_strength("move_left")
	var target_y = Input.get_action_raw_strength("move_down") - Input.get_action_raw_strength("move_up")
	var target_angle = Vector2(target_x, target_y).angle()
	if (Vector2(target_x, target_y).length() > .3):
		a = move_towards_angle(a, target_angle, 4. * delta)
	velocity.x = l * cos(a)
	velocity.y = l * sin(a)
	if position.y > 900.:
		if velocity.length() > 100.:
			if velocity.y > 0:
				velocity.y *= -.7
				velocity.x *= .7
		else:
			dead = true
			for c in chicks:
				c.virtual_position.x = randf_range(-1., 1.)
				c.virtual_position.y = randf_range(-1., 0.)
				c.virtual_position = position + 2000. * c.virtual_position.normalized()
				c.interpolation_factor = 0.
	rotation = a + PI / 2
	move_and_slide()
	
	for body in $Area2D.get_overlapping_bodies():
		if is_instance_of(body, Mechant):
			body.queue_free()
			velocity += velocity.normalized() * 50.
			
			if !$flap_small.is_playing():
				$flap_small.pitch_scale = randf_range(0.9, 1.1)
				$flap_small.play()

func _on_area_2d_body_entered(body: Node2D) -> void:
	print(body)
