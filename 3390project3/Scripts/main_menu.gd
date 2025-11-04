extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_start_game_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Game.tscn")

func _on_sign_out_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Login.tscn")

func _on_upgrades_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Upgrades.tscn")
