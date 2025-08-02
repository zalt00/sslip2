extends RigidBody2D

var max_speed = 200.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _integrate_forces(state):
	if linear_velocity.length()>max_speed:
		linear_velocity=linear_velocity.normalized()*max_speed
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
