extends Node2D

var enemy_scene = preload("res://Scenes/Objects/Enemy1.tscn")

var enemy_health := 1
var enemy_damage := 1
var enemy_speed := 150

var active_enemies: Array = []

func spawn_enemy():
	var enemy = enemy_scene.instantiate()
	
	#stats
	enemy.health = enemy_health
	enemy.damage = enemy_damage
	enemy.speed = enemy_speed
	
	#set random position on map
	enemy.global_position = Vector2(
	randf_range(-1400, 1400),
	randf_range(-1400, 1400))
	
	#add to enemiesFolder and the active enemies array
	get_node("../EnemyFolder").add_child(enemy)
	active_enemies.append(enemy)
	
	if enemy.has_signal("enemy_died"):
		enemy.enemy_died.connect(_on_enemy_died)
	
	return enemy

func _on_enemy_died(enemy):
	active_enemies.erase(enemy)
