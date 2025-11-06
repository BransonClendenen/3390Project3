extends Control

signal menu_closed

func _ready() -> void:
	hide()

func _on_back_pressed() -> void:
	#sends signal to mainmenu and deletes settingsMenuInstance
	hide()
	emit_signal("menu_closed")
	queue_free()
