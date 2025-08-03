extends RemoteTransform2D

@export var bird: Node2D

var shake = 0.
var virtual_position = position

func _process(delta: float) -> void:
	virtual_position = lerp(virtual_position, bird.position, 4. * delta)
	position = virtual_position + shake * Vector2(randf_range(-1., 1.), randf_range(-1., 1.))
	shake = max(shake - 40. * delta, 0.)
