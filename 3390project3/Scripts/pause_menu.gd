extends Control

func _on_resume_pressed() -> void:
	SceneManager.hide_top_overlay()
	get_tree().paused = false

func _on_settings_pressed() -> void:
	SceneManager.load_overlay("res://Scenes/Overlay/SettingsMenu.tscn")

func _on_quit_pressed() -> void:
	SceneManager.hide_all_overlays()
	SceneManager.load_ui("res://Scenes/UI/MainMenu.tscn")
	get_tree().paused = false


func _ready() -> void:
	pass # Replace with function body.

func _process(delta: float) -> void:
	pass
