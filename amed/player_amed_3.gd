extends Node2D
@export var max_speed = 400.0

@onready var body: RigidBody2D = $body
@export var player_id = 1

var current_player = 1
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$body.max_speed = max_speed

const SPEED = 1000.0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	if Input.is_action_just_pressed("move_down"):
		current_player = 3 - current_player
	
	var move_input = 0
	if Input.is_action_pressed("move") and current_player == player_id:
		move_input = 1

	var gpos = body.global_position
	var dpos = (get_global_mouse_position() - gpos).normalized()
	
	var fp = clamp((get_global_mouse_position() - gpos).length()/40.0, 0.0, 1.0)
	
	var velo = dpos * delta * SPEED * move_input * fp

	body.apply_central_force(velo)
	body.linear_damp = 5.0 + (20 * (1.0-fp))
	print(body.linear_velocity.length())
