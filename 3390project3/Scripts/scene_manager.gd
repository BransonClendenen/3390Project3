extends Node

#@onready var root_node = get_tree().root.get_node("")
@onready var root_node: Node = null
@onready var game_scene: Node = null
@onready var overlay_scene: Node = null
@onready var overlay_stack: Array = []

@onready var game_layer: Node2D = null
@onready var ui_layer: CanvasLayer = null
@onready var overlay_layer: CanvasLayer = null

func _ready():
	load_main_scene()

func load_main_scene():
	var packed_root = load("res://Scenes/Game/Root.tscn")
	root_node = packed_root.instantiate()
	get_tree().root.add_child(root_node)
	print("packed scene_root")
	
	await get_tree().process_frame
	setup_layers()

func setup_layers():
	game_layer = root_node.get_node("GameLayer")
	ui_layer = root_node.get_node("UILayer")
	overlay_layer = root_node.get_node("OverlayLayer")
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
	print("Main children:", root_node.get_children())
	print("laod ui entered:")
	print(scene_path)
	print(root_node) 
	print(ui_layer)
	#ui_layer.get_children().map(func(child): child.queue_free())
	
	var new_ui_layer = load(scene_path).instantiate()
	new_ui_layer.size = get_viewport().size
	ui_layer.add_child(new_ui_layer)
	
	print("Loaded new ui:", scene_path)
	print("UI children:", ui_layer.get_children())
	print("UILayer visible:", ui_layer.visible, "layer:", ui_layer.layer)
	
	#print("UI root:", ui_layer, "position:", ui_layer.position, "size:", ui_layer.size)
	for node in ui_layer.get_children():
		print(" -", node.name, "pos:", node.position, "size:", node.size)
	
	print("UILayer visible:", ui_layer.visible)
	print("UI child visible:", new_ui_layer.visible)
	print("UILayer layer:", ui_layer.layer)



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
