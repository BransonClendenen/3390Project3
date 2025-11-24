extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$SpawnTimer.timeout.connect(_on_spawn_timer_timeout)
	$SpawnTimer.start()

func _on_spawn_timer_timeout():
	$EnemyManager.spawn_enemy()

func increase_difficulty():
	pass
