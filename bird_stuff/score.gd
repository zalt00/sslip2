extends Label

@export var bird: Node
@export var spawner: Node

var win = false
var has_sound_played = false

func _process(delta: float) -> void:
	text = str(bird.score) + "/" + str(spawner.num_enemies)
	if bird.score == spawner.num_enemies:
		win = true
		if !has_sound_played:
			has_sound_played = true
			$AudioStreamPlayer.play()
