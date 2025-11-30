extends Control

@onready var health_label: Label = $ExpAndHealth/HealthLabel
@onready var exp_label: Label = $ExpAndHealth/ExpLabel
@onready var time_label: Label = $Timer/TimeLabel
@onready var boss_label: Label = $Timer/BossLabel

func _on_pause_pressed() -> void:
	get_tree().paused = true
	SceneManager.load_overlay("res://Scenes/Overlay/PauseMenu.tscn")

func update_health(current,max):
	health_label.text = "%d / %d" % [current,max]

func update_exp(current,max):
	exp_label.text = "%d / %d" % [current,max]

func update_timer(time_left):
	time_left = floor(time_left)
	time_label.text = "%s sec" % time_left
	if time_left <= 0:
		update_boss_label()

func update_boss_label():
	boss_label.text = "HE IS HERE"
