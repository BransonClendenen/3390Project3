extends Node

@onready var root_node = get_tree().root.get_node("Root")
@onready var game_scene: Node = null
@onready var overlay_scene: Node = null
@onready var overlay_stack: Array = []

func load_scene(scene_path: String):
	if not root_node:
		push_error("Main node not found.")
		return
	
	var game_layer = root_node.get_node("GameLayer")
	#this clears all the children from the game scene, helps against crashes 
	game_layer.get_children().map(func(child): child.queue_free())
	
	var new_game_layer = load(scene_path).instanciate()
	game_layer.add_child(new_game_layer)
	game_scene = new_game_layer
	print("Loaded main scene:", scene_path)


func load_ui(scene_path: String):
	var ui_layer = root_node.get_node("UILayer")
	ui_layer.get_children().map(func(child): child.queue_free())
	
	var new_ui_layer = load(scene_path).instantiate()
	ui_layer.add_child(new_ui_layer)

func load_overlay(scene_path: String):
	var overlay_layer = root_node.get_node("OverlayLayer")
	overlay_layer.get_children().map(func(child): child.queue_free())
	
	var new_overlay_layer = load(scene_path).instanciate()
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
