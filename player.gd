extends CharacterBody2D

var _velocity := Vector2.ZERO

func _ready() -> void:
	print("Hello, world!")

func _physics_process(delta: float) -> void:
	print(position.x, " ", position.y)
	var speed = 600.
	var horizontal_direction = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	var vertical_direction = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	velocity.x = horizontal_direction * speed
	velocity.y = vertical_direction * speed
	move_and_slide()
