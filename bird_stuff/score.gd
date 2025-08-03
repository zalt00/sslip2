extends Label

@export var bird: Node

func _process(delta: float) -> void:
	text = str(bird.score)
