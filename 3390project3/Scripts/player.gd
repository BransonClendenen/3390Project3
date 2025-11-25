extends CharacterBody2D

#wrong they are set here(i am very smart)
var SPEED: int = 0 #some math for something idk
var health: int = 0 #increments hearts on healthbar
var attack_damage: int = 0 #gun damage multiplied by this number
var attack_speed: int = 0 #timer is divided by this number

func _ready():
	SceneManager.reset_stats.connect(_on_reset_stats)
	add_to_group("Player")

func _on_reset_stats(PLAYER_HEALTH, PLAYER_SPEED, PLAYER_ATTACK_SPEED, PLAYER_ATTACK_DAMAGE):
	
	SPEED = PLAYER_SPEED
	health = PLAYER_HEALTH
	attack_damage = PLAYER_ATTACK_DAMAGE
	attack_speed = PLAYER_ATTACK_SPEED
	$Gun.attack_speed = attack_speed
	$Gun.attack_damage = attack_damage

#every time the stats get modified this function gets called to update the player and gun variables
signal stats_changed(attack_damage, attack_speed)

func modify_stats(new_attack_damage,new_attack_speed):
	attack_damage = new_attack_damage
	attack_speed = new_attack_speed
	emit_signal("stats_changed",attack_damage,attack_speed)

func _physics_process(delta: float) -> void:
	var x_direction := Input.get_axis("move_left", "move_right")
	if x_direction:
		velocity.x = x_direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	var y_direction := Input.get_axis("move_up", "move_down")
	if y_direction:
		velocity.y = y_direction * SPEED
	else:
		velocity.y = move_toward(velocity.y, 0, SPEED)
	
	move_and_slide()

func apply_item(item_type: String, value: int):
	match item_type:
		"EXP":
			pass
		"Coin":
			pass
		"Medkit":
			pass
		"Cloak":
			pass


func apply_damage(amount):
	health -= amount
	print("Player took ", amount, " damage!")
	print(health)
	if health <= 0:
		die()

func die():
	SceneManager.load_overlay("res://Scenes/Overlay/GameOver.tscn")
	get_tree().paused = true
	#stop game and end player to game over screen, then to start screen
