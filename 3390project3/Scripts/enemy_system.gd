extends Node2D

const STANDARD_HEALTH = 1
const STANDARD_DAMAGE = 1
const STANDARD_SPEED = 120

const increase_health = 1
const increase_damage = 1
const increase_speed = 10

@onready var boss_timer: Timer = $BossTimer
@onready var spawn_timer: Timer = $SpawnTimer
@onready var enemy_manager: Node2D = $EnemyManager

var total_time = 300
var interval = 30
var last_difficulty_step = 0
var multiplier = 0
var tick_accumulator = 0.0

signal boss_timer_tick(time_left)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	spawn_timer.timeout.connect(_on_spawn_timer_timeout)
	spawn_timer.start()
	boss_timer.start()
	SceneManager.get_enemy_data.connect(send_data)

func send_data():
	SceneManager.game_enemies_killed = enemy_manager.enemies_killed
	SceneManager.game_time_survived = total_time - boss_timer.time_left

func _on_spawn_timer_timeout():
	enemy_manager.spawn_enemy()

func reset_difficulty():
	#when timer is reset, resets enemy stats to base
	enemy_manager.enemy_health = STANDARD_HEALTH 
	enemy_manager.enemy_damage = STANDARD_DAMAGE
	enemy_manager.enemy_speed = STANDARD_SPEED
	enemy_manager.enemies_killed = 0

func increase_difficulty(multiplier):
	enemy_manager.enemy_health += increase_health * multiplier
	enemy_manager.enemy_damage += increase_damage * multiplier
	enemy_manager.enemy_speed += increase_speed * multiplier
	for enemy in enemy_manager.active_enemies:
		enemy.health = enemy_manager.enemy_health
		enemy.damage = enemy_manager.enemy_damage
		enemy.speed = enemy_manager.enemy_speed
	enemy_manager.choose_scene()

func _process(delta):
	tick_accumulator += delta
	
	#emits a signal once per second in order to update the hud overlay
	if tick_accumulator >= 1.0:
		tick_accumulator -= 1.0
		emit_signal("boss_timer_tick",boss_timer.time_left)
	
	if boss_timer.time_left == total_time:
		reset_difficulty()
	var current_step = int((total_time - boss_timer.time_left) / interval)
	if current_step > last_difficulty_step:
		multiplier += 1
		increase_difficulty(multiplier)
		last_difficulty_step = current_step
	elif current_step <= last_difficulty_step:
		pass
	if boss_timer.time_left <= 0:
		enemy_manager.spawn_big_boss()
		boss_timer.stop()
		spawn_timer.stop()
