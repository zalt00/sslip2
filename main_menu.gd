extends Control

func _on_play_pressed() -> void:
	BackgroundMusic.menu_player.stop()
	BackgroundMusic.play()
	get_tree().change_scene_to_file("res://bird_stuff/bird_scene.tscn")

func _on_quit_pressed() -> void:
	get_tree().quit()

func _ready() -> void:
	BackgroundMusic.stop()
	BackgroundMusic.menu_player.play()

func _on_play_mouse_entered() -> void:
	print("HALLO")
	$AudioStreamPlayer.play()


func _on_quit_mouse_entered() -> void:
	print("HALLO")
	$AudioStreamPlayer.play()
