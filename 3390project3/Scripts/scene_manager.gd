extends Node

#@onready var root_node = get_tree().root.get_node("")
@onready var root_node: Node = null
@onready var game_scene: Node = null
@onready var overlay_scene: Node = null
@onready var overlay_stack: Array = []

@onready var game_layer: Node2D = null
@onready var ui_layer: Control = null
@onready var overlay_layer: Control = null

#player stats
const PLAYER_HEALTH: int = 1;
const PLAYER_SPEED: int = 300;
const PLAYER_ATTACK_DAMAGE: int = 1;
const PLAYER_ATTACK_SPEED: int = 1;

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
	print("does this get class3ed")
	#TODO replace signal variable with varibles after updated by profile stats
	emit_signal("reset_stats",PLAYER_HEALTH, PLAYER_SPEED, PLAYER_ATTACK_SPEED, PLAYER_ATTACK_DAMAGE)
	#needs to reset player stats at the start of the game
	#needs to also be added/multiplied by profile stats
