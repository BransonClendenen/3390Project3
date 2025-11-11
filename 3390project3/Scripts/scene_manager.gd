extends Node

#@onready var root_node = get_tree().root.get_node("")
@onready var root_node: Node = null
@onready var game_scene: Node = null
@onready var overlay_scene: Node = null
@onready var overlay_stack: Array = []

@onready var game_layer: Node2D = null
@onready var ui_layer: Control = null
@onready var overlay_layer: Control = null

func _ready():
	setup_layers()
	load_ui("res://Scenes/UI/Login.tscn")

func setup_layers():
	root_node = get_tree().current_scene
	game_layer = root_node.get_node("GameLayer")
	ui_layer = root_node.get_node("UILayer/UIContainer")
	overlay_layer = root_node.get_node("OverlayLayer/OverlayContainer")
	print(game_layer)
	print(ui_layer)
	print(overlay_layer)

func load_scene(scene_path: String):
	if not root_node:
		push_error("Main node not found.")
		return
	
	#var game_layer = root_node.get_node("GameLayer")
	#this clears all the children from the game scene, helps against crashes 
	game_layer.get_children().map(func(child): child.queue_free())
	
	var new_game_layer = load(scene_path).instantiate()
	game_layer.add_child(new_game_layer)
	game_scene = new_game_layer
	print("Loaded main scene:", scene_path)

func load_ui(scene_path: String):
	#ui_layer.get_children().map(func(child): child.queue_free())
	
	var new_ui_layer = load(scene_path).instantiate()
	new_ui_layer.size = get_viewport().size
	ui_layer.add_child(new_ui_layer)
	

func load_overlay(scene_path: String):
	#var overlay_layer = root_node.get_node("OverlayLayer")
	overlay_layer.get_children().map(func(child): child.queue_free())
	
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
