extends Node2D


var item_scenes := {
	"EXP": preload("res://Scenes/Objects/EXP.tscn"),
	"Coin": preload("res://Scenes/Objects/Coin.tscn"),
	"Medkit": preload("res://Scenes/Objects/Medkit.tscn"),
	"Cloak": preload("res://Scenes/Objects/Cloak.tscn")
}

func spawn_item(item_type: String, position: Vector2):
	print("do i get called")
	if not item_scenes.has(item_type):
		push_warning("Unknown item type: %s" % item_type)
		return
	
	var item_instance = item_scenes[item_type].instantiate()
	item_instance.position = position
	add_child(item_instance)
	#print("item spawned!", item_instance, item_instance.position, item_type)
