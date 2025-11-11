extends Node2D

var enemy_scene = preload("res://Scenes/Objects/Enemy1.tscn")
@onready var player: CharacterBody2D = $Player

const MAP_X = 1500
const MAP_Y = 1500

func _on_enemy_spawn_timeout() -> void:
	var enemy = enemy_scene.instantiate()
	
	enemy.global_position = player.global_position
	
	while enemy.global_position.distance_squared_to(player.global_position) < 10000:
		enemy.global_position.x = randi_range(-MAP_X,MAP_X)
		enemy.global_position.y = randi_range(-MAP_Y,MAP_Y)
		
	add_child(enemy)
