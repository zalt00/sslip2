extends CharacterBody2D

@export var playerNumber: int

func _physics_process(delta: float) -> void:
	var primary: Vector2
	primary.x = Input.get_action_raw_strength("move_right") - Input.get_action_raw_strength("move_left")
	primary.y = Input.get_action_raw_strength("move_down") - Input.get_action_raw_strength("move_up")
	var secondary: Vector2
	secondary.x = Input.get_action_raw_strength("move_secondary_right") - Input.get_action_raw_strength("move_secondary_left")
	secondary.y = Input.get_action_raw_strength("move_secondary_down") - Input.get_action_raw_strength("move_secondary_up")
	var movement = primary if playerNumber == 1 else secondary
	velocity = 400. * movement if movement.length() > .3 else Vector2.ZERO
	move_and_slide()
