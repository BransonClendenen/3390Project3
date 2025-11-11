extends Control

func _on_resume_pressed() -> void:
	SceneManager.hide_top_overlay()

func _on_settings_pressed() -> void:
	SceneManager.load_overlay("res://Scenes/Overlay/SettingsMenu.tscn")

func _on_quit_pressed() -> void:
	pass # Replace with function body.


func _ready() -> void:
	pass # Replace with function body.

func _process(delta: float) -> void:
	pass
