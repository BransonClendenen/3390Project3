extends Control

@onready var username: Label = $Profile/Username
@onready var coins: Label = $Profile/Coins

func _on_back_pressed() -> void:
	SceneManager.load_ui("res://Scenes/UI/MainMenu.tscn")

func _on_health_pressed() -> void:
	pass # Replace with function body.
	#these functions will update api variables
	#as well as varibales from scene manager, so another call is not needed each 
	#time the game is run (or whatever is easier idgaf)

func _on_damage_pressed() -> void:
	pass # Replace with function body.

func _on_attack_speed_pressed() -> void:
	pass # Replace with function body.

func _on_move_speed_pressed() -> void:
	pass # Replace with function body.
