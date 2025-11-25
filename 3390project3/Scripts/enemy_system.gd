extends Node2D

const STANDARD_HEALTH = 1
const STANDARD_DAMAGE = 1
const STANDARD_SPEED = 150

const increase_health = 1
const increase_damage = 1
const increase_speed = 20

@onready var boss_timer: Timer = $BossTimer
@onready var spawn_timer: Timer = $SpawnTimer
@onready var enemy_manager: Node2D = $EnemyManager

var total_time = 300
var interval = 30
var last_difficulty_step = 0
var multiplier = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	spawn_timer.timeout.connect(_on_spawn_timer_timeout)
	spawn_timer.start()
	boss_timer.start()

func _on_spawn_timer_timeout():
	enemy_manager.spawn_enemy()

func reset_difficulty():
	#when timer is reset, resets enemy stats to base
	enemy_manager.enemy_health = STANDARD_HEALTH 
	enemy_manager.enemy_damage = STANDARD_DAMAGE
	enemy_manager.enemy_speed = STANDARD_SPEED
	

func increase_difficulty(multiplier):
	enemy_manager.enemy_health += increase_health * multiplier
	enemy_manager.enemy_damage += increase_damage * multiplier
	enemy_manager.enemy_speed += increase_speed * multiplier

func _process(delta):
	if boss_timer.time_left == 300:
		reset_difficulty()
	var current_step = int((total_time - boss_timer.time_left) / interval)
	if current_step > last_difficulty_step:
		multiplier += 1
		increase_difficulty(multiplier)
		last_difficulty_step = current_step
	elif current_step == last_difficulty_step:
		pass
		#SPAWN BOSS RAAAAHHHH
