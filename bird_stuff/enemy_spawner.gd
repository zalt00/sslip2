extends Node2D

@onready var enemy_scene := preload("res://bird_stuff/mechant.tscn")

var num_enemies = 50
var enemies := []
var time_since_last_enemy := 0.

func spawn_enemy() -> void:
	var enemy := enemy_scene.instantiate()
	enemy.position.x = randf_range(Global.limit_left, Global.limit_right)
	enemy.position.x -= fmod(enemy.position.x, 300.)
	var offset := 50
	enemy.position.x += randf_range(-offset, offset)
	enemy.position.y = randf_range(Global.limit_up, Global.limit_down)
	enemy.position.y -= fmod(enemy.position.y, 300.)
	enemy.position.y += randf_range(-offset, offset)
	add_child(enemy)
	enemies.push_back(enemy)

func _ready() -> void:
	seed(12345)
	for i in range(num_enemies):
		spawn_enemy()

func _process(delta: float) -> void:
	if (time_since_last_enemy > 2.):
		#spawn_enemy()
		time_since_last_enemy = 0.
	else:
		time_since_last_enemy += delta

func _on_bird_enemy_killed(enemy) -> void:
	$DeathSound.pitch_scale = randf_range(0.9, 1.1)
	$DeathSound.play()
	enemies.erase(enemy)
