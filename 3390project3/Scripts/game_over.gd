extends Control

func _on_quit_pressed() -> void:
	SceneManager.hide_all_overlays()
	SceneManager.load_ui("res://Scenes/UI/MainMenu.tscn")
	get_tree().paused = false
