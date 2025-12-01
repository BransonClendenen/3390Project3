extends Control

@onready var coins_label: Label = $CoinsLabel

func _ready():
	SceneManager.sending_coins.connect(show_coins)

func show_coins(coins: int):
	coins_label.text = "Coins: %d" % coins

func _on_quit_pressed() -> void:
	SceneManager.hide_all_overlays()
	SceneManager.load_ui("res://Scenes/UI/MainMenu.tscn")
	get_tree().paused = false
