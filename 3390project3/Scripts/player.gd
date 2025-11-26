extends CharacterBody2D

@onready var item_manager: Node2D = $"../ItemManager"

#wrong they are set here(i am very smart)
var speed: int = 0 #some math for something idk
var max_health: int = 0 #increments hearts on healthbar
var current_health: int = 0
var attack_damage: int = 0 #gun damage multiplied by this number
var attack_speed: int = 0 #timer is divided by this number

var level = 0
var next_level = 5
var current_exp = 0

func _ready():
	SceneManager.reset_stats.connect(_on_reset_stats)
	add_to_group("Player")
	item_manager.connect("apply_item", _on_apply_item)

func _on_reset_stats(PLAYER_HEALTH, PLAYER_SPEED, PLAYER_ATTACK_SPEED, PLAYER_ATTACK_DAMAGE):
	#level stats
	level = 0
	next_level = 5
	current_exp = 0
	
	#player stats
	speed = PLAYER_SPEED
	max_health = PLAYER_HEALTH
	current_health = max_health
	attack_damage = PLAYER_ATTACK_DAMAGE
	attack_speed = PLAYER_ATTACK_SPEED
	
	#gun stats
	$Gun.attack_speed = attack_speed
	$Gun.attack_damage = attack_damage

func level_up():
	level += 1
	current_exp -= next_level
	next_level = 2 + level + next_level
	#call level up screen with scene manager
	#print("level up!", level, "current:",current_exp,"next_lvl",next_level)

#every time the stats get modified this function gets called to update the player and gun variables
signal stats_changed(attack_damage, attack_speed)

func modify_stats(add_max_health,add_speed,add_attack_damage,add_attack_speed):
	max_health += add_max_health
	speed += add_speed
	current_health += add_max_health
	attack_damage += add_attack_damage
	attack_speed += add_attack_speed
	emit_signal("stats_changed",attack_damage,attack_speed)

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

func _on_apply_item(item_type: String, value: int):
	match item_type:
		"EXP":
			current_exp += value
			print(current_exp)
			if current_exp >= next_level:
				level_up()
		"Coin":
			pass
		"Medkit":
			pass
		"Cloak":
			pass

func apply_damage(amount):
	current_health -= amount
	print("Player took ", amount, " damage!")
	print(current_health)
	if current_health <= 0:
		die()

func die():
	SceneManager.load_overlay("res://Scenes/Overlay/GameOver.tscn")
	get_tree().paused = true
	#stop game and end player to game over screen, then to start screen
