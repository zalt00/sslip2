extends Node2D
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("move_up"):
		$chain.init_joint()
