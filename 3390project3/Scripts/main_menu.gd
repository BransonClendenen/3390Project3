extends Control

#var settingsMenuScene: PackedScene = preload("res://UI/SettingsMenu.tscn")
#var settingsMenuInstance: Control = null

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	pass

func _on_start_game_pressed() -> void:
	#get_tree().change_scene_to_file("res://Scenes/Game.tscn")\
	pass

func _on_sign_out_pressed() -> void:
	#get_tree().change_scene_to_file("res://Scenes/Login.tscn")
	pass

func _on_upgrades_pressed() -> void:
	#get_tree().change_scene_to_file("res://Scenes/Upgrades.tscn")
	pass

func _on_settings_pressed() -> void:
	#if not settingsMenuInstance:
		#settingsMenuInstance = settingsMenuScene.instantiate()
		#add_child(settingsMenuInstance)
		#settingsMenuInstance.top_level = true
		#settingsMenuInstance.show()
		#settingsMenuInstance.connect("menu_closed", Callable(self, "_on_settings_closed"))
	pass

func _on_settings_closed():
	#settingsMenuInstance = null
	print("Settings menu closed.")
