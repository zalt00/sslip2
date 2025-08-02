extends CharacterBody2D


const SPEED = 400.0
const JUMP_VELOCITY = -400.0
@export var pushForce = 5

func _physics_process(delta: float) -> void:

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	
	
	look_at(get_global_mouse_position())
	var move_input = Input.get_axis("move_down", "move_up")
	
	var gpos = global_position
	var dist = (get_global_mouse_position() - gpos).length()
	velocity = transform.x * move_input * SPEED * lerp(0.0, 1.0, clamp(dist / 10.0, 0.0, 1.0))
	
	if move_and_slide(): # true if collided
		for i in get_slide_collision_count():
			var col = get_slide_collision(i)
			if col.get_collider() is RigidBody2D:
				col.get_collider().apply_force(col.get_normal() * -pushForce)
	
	
