extends Node2D

@onready var enemy_scene := preload("res://bird_stuff/mechant.tscn")

var num_enemies = 50
var enemies := []

func spawn_enemy() -> void:
	var enemy := enemy_scene.instantiate()
	enemy.position.x = randf_range(Global.limit_left, Global.limit_right)
	enemy.position.x -= fmod(enemy.position.x, 200.)
	enemy.position.y = randf_range(Global.limit_up, Global.limit_down)
	enemy.position.y -= fmod(enemy.position.y, 200.)
	add_child(enemy)
	enemies.push_back(enemy)

func _ready() -> void:
	for i in range(num_enemies):
		spawn_enemy()

func _on_bird_enemy_killed(enemy) -> void:
	enemies.erase(enemy)
	spawn_enemy()
