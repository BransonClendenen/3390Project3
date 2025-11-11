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

func load_scene(scene_path: String):
	if not root_node:
		push_error("Main node not found.")
		return
	
	#this clears all the children from the game scene, helps against crashes 
	var last_child_game = game_layer.get_child(game_layer.get_child_count()-1)
	game_layer.remove_child(last_child_game)
	#gets the last child from UI layer and removes it from scene
	var last_child_ui = ui_layer.get_child(ui_layer.get_child_count()-1)
	ui_layer.remove_child(last_child_ui)
	
	#creates new game scene instance
	var new_game_layer = load(scene_path).instantiate()
	#add the game scene to the game layer
	game_layer.add_child(new_game_layer)
	#comments are so cool i know im doing now!!!!
	game_scene = new_game_layer

func load_ui(scene_path: String):
	var last_child_ui = ui_layer.get_child(ui_layer.get_child_count()-1)
	ui_layer.remove_child(last_child_ui)
	
	var new_ui_layer = load(scene_path).instantiate()
	new_ui_layer.size = get_viewport().size
	ui_layer.add_child(new_ui_layer)
	

func load_overlay(scene_path: String):
	var last_child_overlay = overlay_layer.get_child(overlay_layer.get_child_count()-1)
	overlay_layer.remove_child(last_child_overlay)
	
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
