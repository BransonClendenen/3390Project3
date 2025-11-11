extends Control

#var settingsMenuScene: PackedScene = preload("res://UI/SettingsMenu.tscn")
#var settingsMenuInstance: Control = null

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	pass

func _on_start_game_pressed() -> void:
	SceneManager.load_scene("res://Scenes/Game/Game.tscn")
	SceneManager.load_overlay("res://Scenes/Overlay/Huzz.tscn")

func _on_sign_out_pressed() -> void:
	SceneManager.load_ui("res://Scenes/UI/Login.tscn")

func _on_upgrades_pressed() -> void:
	SceneManager.load_ui("res://Scenes/UI/Upgrades.tscn")

func _on_settings_pressed() -> void:
	SceneManager.load_overlay("res://Scenes/Overlay/SettingsMenu.tscn")
