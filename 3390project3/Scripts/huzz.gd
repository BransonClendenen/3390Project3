extends Control

func _on_pause_pressed() -> void:
	get_tree().paused = true
	SceneManager.load_overlay("res://Scenes/Overlay/PauseMenu.tscn")
