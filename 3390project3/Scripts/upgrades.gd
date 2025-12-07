extends Control
#do we need to adjust price_check so it updates the correct *_level and *_price variables?
#what behavior do we want for applylevel and pricecheck
#make sure values sent via stats_to_manager match what players actually see?

@onready var username: Label = $Profile/Username
@onready var coins_label: Label = $Profile/Coins

@onready var health: Button = $ButtonManager/Health
@onready var damage: Button = $ButtonManager/Damage
@onready var attack_speed: Button = $ButtonManager/AttackSpeed
@onready var move_speed: Button = $ButtonManager/MoveSpeed

var health_level = SceneManager.profile_max_health
var speed_level = SceneManager.profile_speed
var attack_damage_level = SceneManager.profile_attack_damage
var attack_speed_level = SceneManager.profile_attack_speed
var coins = SceneManager.profile_coins

var health_price
var speed_price
var attack_damage_price
var attack_speed_price

var base_price = 2
var max_level = 10

func _ready() -> void:
	username.text = "Good Evening " + SceneManager.username
	coins_label.text = "Coins: " + str(coins)
	health_price = apply_level(health,health_level,max_level)
	speed_price = apply_level(move_speed,speed_level,max_level)
	attack_damage_price = apply_level(damage,attack_damage_level,max_level)
	attack_speed_price = apply_level(attack_speed,attack_speed_level,max_level)

signal stats_to_manager(coins,speed_level,health_level,attack_damage_level,attack_speed_level)

func _on_back_pressed() -> void:
	#should send information to api about any stat changes
	SceneManager.profile_max_health = health_level
	SceneManager.profile_speed = speed_level
	SceneManager.profile_attack_damage = attack_damage_level
	SceneManager.profile_attack_speed = attack_speed_level
	print("settings:",speed_level,health_level,attack_damage_level,attack_speed_level)
	print("manager:",SceneManager.profile_speed,SceneManager.profile_max_health,SceneManager.profile_attack_damage,SceneManager.profile_attack_speed)
	emit_signal("stats_to_manager",coins,speed_level,health_level,attack_damage_level,attack_speed_level)
	SceneManager.load_ui("res://Scenes/UI/MainMenu.tscn")

func _on_health_pressed() -> void:
	if(price_check(health_price,health_level,max_level,health)):
		health_level += 1
	else:
		pass #this is where we left off eheheheheh <<<3333  FIX FUNC BELOW <<<3333

func _on_damage_pressed() -> void:
	if(price_check(attack_damage_price,attack_damage_level,max_level,damage)):
		attack_damage_level += 1
	else:
		pass

func _on_attack_speed_pressed() -> void:
	if(price_check(attack_speed_price,attack_speed_level,max_level,attack_speed)):
		attack_speed_level += 1
	else:
		pass

func _on_move_speed_pressed() -> void:
	if(price_check(speed_price,speed_level,max_level,move_speed)):
		speed_level += 1
	else:
		pass

func apply_level(label,current:int,max:int):
	var price = (base_price*current)+2
	label.text = "%d / %d" % [current,max] + "\n Price: " + str(price)
	return price

func price_check(stat_price:int,current:int,max:int,label):
	if(current == max):
		print("max level")
		return false
	if(stat_price > coins):
		print("haha poor")
		return false
	else:
		coins = coins - stat_price
		current += 1
		stat_price = apply_level(label,current,max)
		coins_label.text = "Coins: " + str(coins)
		return true
