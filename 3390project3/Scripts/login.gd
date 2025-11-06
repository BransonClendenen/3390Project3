extends Node2D

@onready var status_label = $StatusLabel

@onready var password_field = $passwordField
@onready var username_field = $usernameField

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
func _on_create_account_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/MainMenu.tscn")

func _on_sign_in_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/MainMenu.tscn")
