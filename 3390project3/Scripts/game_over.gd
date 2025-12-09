extends Control

@onready var coins_label: Label = $CoinsLabel
@onready var label: Label = $Label

func _ready():
	SceneManager.sending_coins.connect(show_coins)
	SceneManager.play_agartha.connect(check_win)

func show_coins(coins: int):
	coins_label.text = "Coins: %d" % coins

func _on_quit_pressed() -> void:
	SceneManager.hide_all_overlays()
	SceneManager.load_ui("res://Scenes/UI/MainMenu.tscn")
	get_tree().paused = false
	AudioManager.stop_music()
	AudioManager.play_music("res://Sounds/menu_music.mp3")

func check_win(win):
	print("does this get reached")
	print("win val: ",win)
	if win == 1 :
		print("does THIS get called")
		AudioManager.play_sfx("res://Sounds/celebration.mp3",30)
		AudioManager.play_sfx("res://Sounds/AGARTHA.mp3",30)
		label.text = "You congratulations!"
	if win == 0 :
		AudioManager.play_sfx("res://Sounds/game_over.mp3",30)
		label.text = "Oh NO you dead!"
