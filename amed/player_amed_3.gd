extends Node2D
@export var max_speed = 200.0

@onready var body: RigidBody2D = $body
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$body.max_speed = max_speed

const SPEED = 1000.0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	var move_input = Input.get_axis("move_down", "move_up")
	
	var gpos = body.global_position
	var dpos = (get_global_mouse_position() - gpos).normalized()
	
	var fp = clamp((get_global_mouse_position() - gpos).length()/40.0, 0.0, 1.0)
	
	var velo = dpos * delta * SPEED * move_input * fp

	body.apply_central_force(velo)
	body.linear_damp = 5.0 + (20 * (1.0-fp))
	print(body.linear_velocity.length())
