extends Node

@onready var sfx_container = SceneManager.sfx_container
@onready var music_player = SceneManager.music_player

var current_music_path: String = ""
var master_volume = 20.0
var sfx_volume = 20.0

signal music_finished
signal sfx_played(name : String)

func _ready():
	print(master_volume)
	#set_master_volume(master_volume)
	play_music("res://Sounds/menu_music.mp3")
	play_sfx("res://Sounds/game_open.mp3",20)

#func set_master_volume(value: float):
	#music_player.volume_db = value
	#
	#for child in sfx_container.get_children():
		#if child is AudioStreamPlayer:
			#child.volume_db = value

func play_music(path: String):
	if current_music_path == path:
		return
	
	current_music_path = path
	var stream = load(path)
	music_player.stream = stream
	music_player.volume_db = master_volume
	music_player.play()

func stop_music():
	music_player.stop()
	current_music_path = ""

func play_sfx(path: String, volume: float):
	var stream = load(path)
	var player = AudioStreamPlayer.new()
	player.stream = stream
	player.volume_db = volume
	sfx_container.add_child(player)
	player.play()
	
	player.finished.connect(func():
		player.queue_free()
	)
	
	emit_signal("sfx_played", path)

func _on_music_player_finished() -> void:
	play_music(current_music_path)
	emit_signal("music_finished")
