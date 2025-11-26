extends Node2D

signal apply_item(item_type: String, value: int)

var item_scenes := {
	"EXP": preload("res://Scenes/Objects/EXP.tscn"),
	"Coin": preload("res://Scenes/Objects/Coin.tscn"),
	"Medkit": preload("res://Scenes/Objects/Medkit.tscn"),
	"Cloak": preload("res://Scenes/Objects/Cloak.tscn")
}
var item_weight := {
	"EXP": 60,
	"Coin": 25,
	"Medkit": 10,
	"Cloak": 5
}

func get_weighted_item() -> String:
	var total_weight = 0
	
	for weight in item_weight.values():
		total_weight += weight
	
	var random_value = randf() * total_weight
	
	var current = 0
	for item in item_weight.keys():
		current += item_weight[item]
		if random_value <= current:
			return item
	
	return "EXP"

func spawn_item(item_type: String, position: Vector2):
	#print("do i get called")
	if not item_scenes.has(item_type):
		push_warning("Unknown item type: %s" % item_type)
		return
	
	var item_instance = item_scenes[item_type].instantiate()
	item_instance.connect("picked_up", _item_picked_up)
	item_instance.position = position
	add_child(item_instance)
	#print("item spawned!", item_instance, item_instance.position, item_type)

func spawn_random_item(position: Vector2):
	var item_type = get_weighted_item()
	spawn_item(item_type, position)

func _item_picked_up(item_type: String, value: int):
	emit_signal("apply_item", item_type, value)
	
