extends Node

var current_scene: Node = null
var overlay_scene: Node = null
var root_node: Node = null

func _ready() -> void:
	root_node = get_tree().root.get_node("Root")

func load_scene(scene_path: String):
	if not root_node:
		push_error("Main node not found.")
		return
	
	var game_layer = root_node.get_node("GameLayer")
	#this clears all the children from the game scene, helps against crashes 
	game_layer.get_children().map(func(child): child.queue_free())
	
	var new_scene = load(scene_path).instanciate()
	game_layer.add_child(new_scene)
	current_scene = new_scene
	print("Loaded main scene:", scene_path)


func load_ui(scene_path: String):
	var ui_layer = root_node.get_node("UILayer")
	ui_layer.get_children().map(func(child): child.queue_free())
	
	var ui_scene = load(scene_path).instantiate()
	ui_layer.add_child(ui_scene)
