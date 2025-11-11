extends Control

func _on_pause_pressed() -> void:
	SceneManager.load_overlay("res://Scenes/Overlay/PauseMenu.tscn")
