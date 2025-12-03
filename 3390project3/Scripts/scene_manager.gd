extends Node

@onready var root_node: Node = null
@onready var game_scene: Node = null
@onready var overlay_scene: Node = null
@onready var overlay_stack: Array = []

@onready var game_layer: Node2D = null
@onready var ui_layer: Control = null
@onready var overlay_layer: Control = null

#this will be commented out in login.gd temp
var API_BASE := "http://localhost:3000/api/auth"
var auth_token := ""
var last_action := ""

#player stats
var player
const PLAYER_HEALTH: int = 3;
const PLAYER_SPEED: int = 300;
const PLAYER_ATTACK_DAMAGE: int = 1;
const PLAYER_ATTACK_SPEED: int = 1;

var ui
var huzz
var enemy_manager

func _ready():
	setup_layers()
	load_ui("res://Scenes/UI/Login.tscn")

func setup_layers():
	root_node = get_tree().current_scene
	game_layer = root_node.get_node("GameLayer")
	ui_layer = root_node.get_node("UILayer/UIContainer")
	overlay_layer = root_node.get_node("OverlayLayer/OverlayContainer")

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

func load_ui(scene_path: String):
	game_layer.get_children().map(func(child): child.queue_free())
	ui_layer.get_children().map(func(child): child.queue_free())
	
	var new_ui_layer = load(scene_path).instantiate()
	new_ui_layer.size = get_viewport().size
	ui_layer.add_child(new_ui_layer)
	

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
	
	#if ANYTHING is moved in tree you have to change number in get_child()
	#spahgetti code to rule all spahgetti code
	#anyways this defines variables and makes connections for the huzz
	enemy_manager = game_scene.get_child(1)
	huzz = overlay_scene
	player.health_changed.connect(huzz.update_health)
	player.exp_changed.connect(huzz.update_exp)
	enemy_manager.boss_timer_tick.connect(huzz.update_timer)

	#TODO replace signal variable with varibles after updated by profile stats
	emit_signal("reset_stats",PLAYER_HEALTH, PLAYER_SPEED, PLAYER_ATTACK_SPEED, PLAYER_ATTACK_DAMAGE)
	#needs to reset player stats at the start of the game
	#needs to also be added/multiplied by profile stats

#so as seen in game_start() theres a way easier way to make connections that only
#takes 5 lines of code for 3 signals between two objects, instead of
#all this bullshit i wrote below, the more you learn

#this is all for the lvl up overlay
signal randomize_level_up()

func show_level_up():
	#print(overlay_stack,overlay_scene,overlay_layer)
	ui = overlay_scene
	ui.increase_stat.connect(ui_to_player_stat)
	emit_signal("randomize_level_up")

signal increase_player_stat(upgrade_name: String,upgrade_amount: int)

func ui_to_player_stat(upgrade_name,upgrade_amount):
	emit_signal("increase_player_stat",upgrade_name,upgrade_amount)
#end lvl up ui

signal sending_coins(current_coins)

func send_coins(current_coins):
	emit_signal("sending_coins",current_coins)
