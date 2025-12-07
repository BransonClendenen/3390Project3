extends Node

@onready var root_node: Node = null
@onready var game_scene: Node = null
@onready var overlay_scene: Node = null
@onready var overlay_stack: Array = []
@onready var sfx_container: Node = null
@onready var music_player: AudioStreamPlayer2D = null

@onready var game_layer: Node2D = null
@onready var ui_layer: Control = null
@onready var overlay_layer: Control = null

#this will be commented out in login.gd temp
var http_request: HTTPRequest 
var API_BASE = "http://localhost:3000/api/auth"
var auth_token = ""
var last_action = ""
var username = ""

#player stats
var player
const PLAYER_HEALTH: int = 3;
const PLAYER_SPEED: int = 300;
const PLAYER_ATTACK_DAMAGE: int = 1;
const PLAYER_ATTACK_SPEED: int = 1;

#profile stats
var profile_coins: int
var profile_max_health: int
var profile_speed: int
var profile_attack_damage: int
var profile_attack_speed: int

#scene variables
var ui
var huzz
var enemy_manager

#previous game data
var game_exp_earned = 0
var game_coins_collected = 0
var game_enemies_killed = 0
var game_time_survived = 0


func _ready() -> void:
	setup_layers()
	load_ui("res://Scenes/UI/Login.tscn")

func setup_layers() -> void:
	root_node = get_tree().current_scene
	game_layer = root_node.get_node("GameLayer")
	ui_layer = root_node.get_node("UILayer/UIContainer")
	overlay_layer = root_node.get_node("OverlayLayer/OverlayContainer")
	sfx_container = root_node.get_node("SFXContainer")
	music_player = root_node.get_node("MusicPlayer")
	#http_request = root_node.get_child(4)
	
	if root_node.has_node("HTTPRequest"):
		http_request = root_node.get_node("HTTPRequest") as HTTPRequest #shared http req for the whole game 
	else:
		# fallback to old position if it evne exists
		var candidate = null
		if root_node.get_child_count() > 4:
			candidate = root_node.get_child(4)
		if candidate is HTTPRequest:
			http_request = candidate
		else:
			http_request = HTTPRequest.new()
			http_request.name = "HTTPRequest"
			root_node.add_child(http_request)

func apply_profile_stats(user: Dictionary) -> void: #consume prof stats
	#here the api will pull the data
	#the api should return an array of some sort
	#the profile stats (delcared above) get set to array values
	profile_coins = int(user.get("profile_coins", 0))
	profile_max_health = int(user.get("profile_max_health", profile_max_health))
	profile_speed = int(user.get("profile_speed", profile_speed))
	profile_attack_damage = int(user.get("profile_attack_damage", profile_attack_damage))
	profile_attack_speed = int(user.get("profile_attack_speed", profile_attack_speed))


func load_scene(scene_path: String):
	if not root_node:
		push_error("Main node not found.")
		return
	
	#this clears all the children from the game scene, helps against crashes 
	game_layer.get_children().map(func(child): child.queue_free())
	ui_layer.get_children().map(func(child): child.queue_free())
	
	#creates new game scene instance
	var new_game_layer = load(scene_path).instantiate()
	#add the game scene to the game layer
	game_layer.add_child(new_game_layer)
	#comments are so cool i know im doing now!!!!
	game_scene = new_game_layer
	AudioManager.play_music("res://Sounds/game_music.mp3")

func load_ui(scene_path: String):
	game_layer.get_children().map(func(child): child.queue_free())
	ui_layer.get_children().map(func(child): child.queue_free())
	
	var new_ui_layer = load(scene_path).instantiate()
	new_ui_layer.size = get_viewport().size
	ui_layer.add_child(new_ui_layer)
	
	#if this ui emits stats_to_manager (Upgrades screen), hook it
	if new_ui_layer.has_signal("stats_to_manager"):
		new_ui_layer.stats_to_manager.connect(_on_stats_from_upgrades)

func _on_stats_from_upgrades(coins: int, speed_level: int, health_level: int, attack_damage_level: int, attack_speed_level: int) -> void:
	
	#this update profile stats from  upgrades scene
	profile_coins = coins
	profile_speed = speed_level
	profile_max_health = health_level
	profile_attack_damage = attack_damage_level
	profile_attack_speed = attack_speed_level

	#printin
	print("here are da updated profile stats from Upgrades:",
		"coins=", profile_coins,
		" health=", profile_max_health,
		" speed=", profile_speed,
		" dmg=", profile_attack_damage,
		" atk_spd=", profile_attack_speed
	)
	save_profile_stats_to_server()
	
func save_profile_stats_to_server() -> void:
	if auth_token == "" or http_request == null:
		print("No auth token or httprequest; cannot save ur stats.")
		return

	var payload :={
		"profile_coins": profile_coins,
		"profile_max_health": profile_max_health,
		"profile_speed": profile_speed,
		"profile_attack_damage": profile_attack_damage,
		"profile_attack_speed": profile_attack_speed,
	}
		
	var headers :=[
		"Content-Type: application/json",
		"Authorization: " + "Bearer " + auth_token
	]

	var url = API_BASE + "/stats"
	var err := http_request.request(url, headers, HTTPClient.METHOD_PUT, JSON.stringify(payload))
	if err != OK:
		print("there was an error sending stats update:", err)

func load_overlay(scene_path: String):
	var new_overlay_layer = load(scene_path).instantiate()
	overlay_layer.add_child(new_overlay_layer)
	overlay_scene = new_overlay_layer
	overlay_stack.append(new_overlay_layer)

func hide_top_overlay():
	if overlay_stack.is_empty():
		return
	
	var top_overlay = overlay_stack.pop_back()
	top_overlay.queue_free()
	print("Overlay hidden. Remaining overlays:", overlay_stack.size())

func hide_all_overlays():
	for overlay in overlay_stack:
		overlay.queue_free()
	overlay_stack.clear()
	overlay_scene = null
	print("All overlays cleared")

signal reset_stats(PLAYER_HEALTH, PLAYER_SPEED, PLAYER_ATTACK_SPEED, PLAYER_ATTACK_DAMAGE)

func game_start():
	player = get_tree().get_first_node_in_group("Player")
	player.show_level_up_overlay.connect(show_level_up)
	player.display_coins.connect(send_coins)
	player.display_exp.connect(send_exp)
	player.apply_cloak.connect(apply_cloak)
	
	#if ANYTHING is moved in tree you have to change number in get_child()
	#spahgetti code to rule all spahgetti code
	#anyways this defines variables and makes connections for the huzz
	#in 2002 i hit a guy on a bike under the influence and was never caught or arrested for it
	enemy_manager = game_scene.get_child(1)
	huzz = overlay_scene
	player.health_changed.connect(huzz.update_health)
	player.exp_changed.connect(huzz.update_exp)
	enemy_manager.boss_timer_tick.connect(huzz.update_timer)
	
	var max_health = PLAYER_HEALTH + profile_max_health
	var speed = PLAYER_SPEED + (profile_speed*30)
	var attack_damage = PLAYER_ATTACK_DAMAGE + profile_attack_damage
	var attack_speed = PLAYER_ATTACK_SPEED + profile_attack_speed
	
	#TODO replace signal variable with varibles after updated by profile stats <<loser
	emit_signal("reset_stats", max_health, speed, attack_speed, attack_damage)
	#emit_signal("reset_stats",PLAYER_HEALTH, PLAYER_SPEED, PLAYER_ATTACK_SPEED, PLAYER_ATTACK_DAMAGE)
	
	#needs to reset player stats at the start of the game
	#needs to also be added/multiplied by profile stats

#so as seen in game_start() theres a way easier way to make connections that only
#takes 5 lines of code for 3 signals between two objects, instead of
#all this bullshit i wrote below, the more you learn

#this is all for the lvl up overlay
signal randomize_level_up()

func show_level_up():
	print(overlay_stack,overlay_scene,overlay_layer)
	ui = overlay_scene
	ui.increase_stat.connect(ui_to_player_stat)
	emit_signal("randomize_level_up")

signal increase_player_stat(upgrade_name: String,upgrade_amount: int)

func ui_to_player_stat(upgrade_name,upgrade_amount):
	emit_signal("increase_player_stat",upgrade_name,upgrade_amount)
#end lvl up ui

signal sending_coins(current_coins)

func send_coins(current_coins):
	profile_coins += current_coins
	game_coins_collected = current_coins
	get_game_data()
	emit_signal("sending_coins",current_coins)

func send_exp(exp):
	game_exp_earned = exp

signal get_enemy_data()

#FOR PAOLA RIGHTG HERE HEKLO DO THIS
func get_game_data():
	game_coins_collected
	game_exp_earned
	emit_signal("get_enemy_data")
	game_enemies_killed
	game_time_survived
	print("coins",game_coins_collected,"exp:",game_exp_earned,"enemies:",game_enemies_killed,"time",floor(game_time_survived))

signal cloak_to_enemy()

func apply_cloak():
	emit_signal("cloak_to_enemy")
