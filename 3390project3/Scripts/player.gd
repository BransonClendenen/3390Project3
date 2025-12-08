extends CharacterBody2D

@onready var item_manager: Node2D = $"../ItemManager"

#wrong they are set here(i am very smart)
var speed: int = 0 #some math for something idk
var max_health: int = 0 #increments hearts on healthbar
var current_health: int = 0
var attack_damage: int = 0 #gun damage multiplied by this number
var attack_speed: int = 0 #timer is divided by this number

var level = 0
var next_level = 0
var current_exp = 0

var total_exp = 0
var current_coins = 0

#these connect to the ui for real time stat updates
signal health_changed(current,max)
signal exp_changed(current, max)
#every time the stats get modified this function gets called to update the player and gun variables
signal gun_attack_damage_changed(attack_damage)
signal gun_attack_speed_changed(attack_speed)
#gets called in level_up() and starts the chain for the lvl up screen and logic
signal show_level_up_overlay()
#called to display coins on end game screen
signal display_coins(current_coins)
signal display_exp(total_exp)

func _ready():
	SceneManager.reset_stats.connect(_on_reset_stats)
	add_to_group("Player")
	item_manager.connect("apply_item", _on_apply_item)
	SceneManager.increase_player_stat.connect(_increase_player_stat)

func _on_reset_stats(PLAYER_HEALTH, PLAYER_SPEED, PLAYER_ATTACK_SPEED, PLAYER_ATTACK_DAMAGE):
	#level stats
	level = 0
	next_level = 3
	current_exp = 0
	total_exp = 0 
	
	#coin stat
	current_coins = 0
	
	#player stats
	speed = PLAYER_SPEED
	max_health = PLAYER_HEALTH
	current_health = max_health
	attack_damage = PLAYER_ATTACK_DAMAGE
	attack_speed = PLAYER_ATTACK_SPEED
	
	#gun stats
	$Gun.attack_speed = attack_speed
	$Gun.attack_damage = attack_damage
	
	emit_signal("exp_changed", current_exp, next_level)
	emit_signal("health_changed", current_health, max_health)

func level_up():
	level += 1
	current_exp -= next_level
	next_level = 2 + level + next_level
	SceneManager.load_overlay("res://Scenes/Overlay/LevelUp.tscn")
	emit_signal("show_level_up_overlay")
	emit_signal("exp_changed", current_exp, next_level)
	#print("level up!", level, "current:",current_exp,"next_lvl",next_level)

func _increase_player_stat(stat_name: String, amount: int):
	#print("increase stat called we fucking good")
	#print("spped",speed,"maxhealth",max_health,"currhealth",current_health,"damage",attack_damage,"spped",attack_speed)
	#okay so this shit is dumb, just make a switch statement
	match stat_name:
		"speed":
			speed += amount * 30
		"max_health":
			max_health += amount
			if((current_health + amount) > max_health):
				current_health = max_health
			else:
				current_health += amount
			emit_signal("health_changed", current_health, max_health)
		"attack_damage":
			attack_damage += amount
			emit_signal("gun_attack_damage_changed",attack_damage)
		"attack_speed":
			attack_speed += amount
			emit_signal("gun_attack_speed_changed",attack_speed)
	#print("spped",speed,"maxhealth",max_health,"currhealth",current_health,"damage",attack_damage,"spped",attack_speed)

#previous function before refactor, too large and stupid to be helpful
#solution? make another large and stupid function but better
#func modify_stats(add_max_health,add_speed,add_attack_damage,add_attack_speed):
	#max_health += add_max_health
	#speed += add_speed
	#current_health += add_max_health
	#attack_damage += add_attack_damage
	#attack_speed += add_attack_speed
	#emit_signal("stats_changed",attack_damage,attack_speed)

func _physics_process(delta: float) -> void:
	var x_direction := Input.get_axis("move_left", "move_right")
	if x_direction:
		velocity.x = x_direction * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
	
	var y_direction := Input.get_axis("move_up", "move_down")
	if y_direction:
		velocity.y = y_direction * speed
	else:
		velocity.y = move_toward(velocity.y, 0, speed)
	
	move_and_slide()

signal apply_cloak()

func _on_apply_item(item_type: String, value: int):
	match item_type:
		"EXP":
			current_exp += value
			total_exp += 1
			#print(current_exp)
			emit_signal("exp_changed", current_exp, next_level)
			if current_exp >= next_level:
				get_tree().paused = true
				level_up()
		"Coin":
			current_coins += value
			#print(current_coins)
		"Medkit":
			if((current_health + value) > max_health):
				current_health = max_health
			else:
				current_health += value
			emit_signal("health_changed", current_health, max_health)
			#print(current_health, max_health)
		"Cloak":
			emit_signal("apply_cloak")

func apply_damage(amount):
	current_health -= amount
	#print("Player took ", amount, " damage!")
	#print(current_health)
	emit_signal("health_changed", current_health, max_health)
	if current_health <= 0:
		die()

func die():
	SceneManager.load_overlay("res://Scenes/Overlay/GameOver.tscn")
	emit_signal("display_exp",total_exp)
	emit_signal("display_coins",current_coins)
	get_tree().paused = true
	#stop game and end player to game over screen, then to start screen
