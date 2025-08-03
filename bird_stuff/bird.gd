extends CharacterBody2D

signal enemy_killed

@export var enemy_spawner: Node2D

@onready var chick_scene = preload("res://bird_stuff/chick.tscn")
#@onready var collision_polygon_2d: CollisionPolygon2D = $Area2D/CollisionPolygon2D

class Chick:
	var node: ChickNode
	var virtual_position: Vector2
	var interpolation_factor: float
	func _init(n, v, i):
		node = n
		virtual_position = v
		interpolation_factor = i
		
	func set_position(v: Vector2):
		var dpos = v - node.position
		node.sprite.rotation = dpos.angle()
		node.position = v
		
var num_positions
var previous_positions = []
var num_chicks = 41
var chick_interval = 5
var chicks: Array = []
var time_since_last_loop = 0
var dead = false
var can_dash = true
var time_since_last_dash := 0.
var score := 0

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
	if dead:
		if Input.get_action_strength("restart") > .5:
			get_tree().reload_current_scene()
	else:
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
					if time_since_last_loop >= 1. and (j-i + 1) > 10:
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
							chicks[k].set_position(chicks[k + (j - i + 1) / 2].node.position)
							chicks[k + (j - i + 1) / 2].set_position(tmp)
						var polygon: PackedVector2Array = []
						for k in range(i, j + 1):
							polygon.append(to_local(chicks[k].virtual_position))
						$Area2D/CollisionShape2D.shape.points = polygon
						break
			if loop_found:
				break
				
	for i in range(num_chicks):
		chicks[i].interpolation_factor = lerp(chicks[i].interpolation_factor, 10., 1. * delta)
		chicks[i].set_position(lerp(chicks[i].node.position, chicks[i].virtual_position, chicks[i].interpolation_factor * delta))
		var sprite = chicks[i].node.sprite
		if -PI/2.0 <= sprite.global_rotation and sprite.global_rotation <= PI/2.0:
			sprite.scale.y = abs(sprite.scale.y)
		else:
			sprite.scale.y = -abs(sprite.scale.y)
	
	
func move_towards_angle(current: float, target: float, delta: float) -> float:
	var diff = wrapf(target - current, -PI, PI)
	if abs(diff) < delta:

		return target
	return current + sign(diff) * delta

func _physics_process(delta: float) -> void:
	if dead:
		return
	var target_x = Input.get_action_raw_strength("move_right") - Input.get_action_raw_strength("move_left")
	var target_y = Input.get_action_raw_strength("move_down") - Input.get_action_raw_strength("move_up")
	
	if Input.is_action_pressed("move"):
		var mpos = get_global_mouse_position()
		var dpos = mpos - global_position
		var vec = dpos.normalized()
		target_x = vec[0]
		target_y = vec[1]
	
	time_since_last_dash += delta
	if can_dash && Input.get_action_strength("dash") > .5:
		time_since_last_dash = 0.
		can_dash = false
		velocity = 900. * Vector2(target_x, target_y).normalized()
		
	velocity.y += 600. * delta #* (1 + cos(velocity.angle()) ** 2) / 2
	var l = velocity.length()
	var a = velocity.angle()
	
	var target_angle = Vector2(target_x, target_y).angle()
	if (Vector2(target_x, target_y).length() > .3):
		a = move_towards_angle(a, target_angle, 3 * delta)
	velocity.x = l * cos(a)
	velocity.y = l * sin(a)
	if position.x < Global.limit_left && velocity.x < 0:
		velocity.x *= -1.
	if position.x > Global.limit_right && velocity.x > 0:
		velocity.x *= -1.
	if position.y < Global.limit_up && velocity.y < 0.:
		velocity.y *= -1.
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
	if velocity.length() > 750. && time_since_last_dash > 1.5:
		velocity -= delta * velocity
	move_and_slide()
	print(velocity.length())
	
	for body in $Area2D.get_overlapping_bodies():
		if is_instance_of(body, Mechant):
			score += 1
			can_dash = true
			enemy_killed.emit(body)
			body.queue_free()
			#velocity += velocity.normalized() * 25.
			
			if !$flap_small.is_playing():
				$flap_small.pitch_scale = randf_range(0.9, 1.1)
				$flap_small.play()
				
	if 0 <= global_rotation and global_rotation <= PI:
		$AnimatedSprite2D.scale.y = abs($AnimatedSprite2D.scale.y)
	else:
		$AnimatedSprite2D.scale.y = -abs($AnimatedSprite2D.scale.y)

func _on_area_2d_body_entered(body: Node2D) -> void:
	print(body)
