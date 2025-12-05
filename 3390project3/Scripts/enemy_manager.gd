extends Node2D

var enemy_scene = preload("res://Scenes/Objects/Enemy1.tscn")
var big_boss_scene = preload("res://Scenes/Objects/BigBoss.tscn")

@onready var item_manager: Node2D = $"../../ItemManager"


var enemy_health := 0
var enemy_damage := 0
var enemy_speed := 0

var active_enemies: Array = []

func _ready():
	SceneManager.cloak_to_enemy.connect(apply_cloak)

#functions for the invince cloak(by god it is awful)
func apply_cloak():
	for enemy in active_enemies:
		enemy.damage = 0
	await get_tree().create_timer(10).timeout
	unapply_cloak()

func unapply_cloak():
	for enemy in active_enemies:
		enemy.damage = enemy_damage

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
	#chosen = item_types[randi() % item_types.size()]
	item_manager.spawn_random_item(enemy.position)
	active_enemies.erase(enemy)

func spawn_big_boss():
	var boss = big_boss_scene.instantiate()
	
	#stats
	boss.health = enemy_health * 10
	boss.damage = enemy_damage
	boss.speed = enemy_speed / 2
	
	#set random position on map
	boss.global_position = Vector2(
	randf_range(-100, 100),
	randf_range(-400, 100))
	
	#add to enemiesFolder and the active enemies array
	get_node("../EnemyFolder").add_child(boss)
	active_enemies.append(boss)
	
	if boss.has_signal("enemy_died"):
		boss.enemy_died.connect(_on_enemy_died)
	
	return boss
