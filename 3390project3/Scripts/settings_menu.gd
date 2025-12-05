extends Control

@onready var volume_slider: HSlider = $PanelContainer/VBoxContainer/VolumeSlider
@onready var mute_check_box: CheckBox = $PanelContainer/VBoxContainer/MuteCheckBox

signal master_volume_changed(value : float)
signal connect_scene_manager(settings_menu)

var master_volume = SceneManager.master_volume

func _ready() -> void:
	emit_signal("connect_scene_manager", self)
	print("connected to manager")
	volume_slider.value = master_volume
	if master_volume == 0:
		mute_check_box.value = 1

func _on_back_pressed() -> void:
	SceneManager.hide_top_overlay()

func _on_volume_slider_drag_ended(value_changed: bool) -> void:
	emit_signal("master_volume_changed",volume_slider.value)
	print("signal from settings")

func _on_mute_check_box_toggled(toggled_on: bool) -> void:
	if toggled_on == true:
		emit_signal("master_volume_changed", 0)
	else:
		emit_signal("master_volume_changed",volume_slider.value)
