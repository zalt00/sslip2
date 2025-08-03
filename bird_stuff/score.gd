extends Label

@export var bird: Node

func _process(delta: float) -> void:
	print(bird.score)
	text = str(bird.score)
