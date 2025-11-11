extends Node2D

var is_ready: bool = true
const BULLET = preload("res://Scenes/Objects/Bullet.tscn")
@onready var cooldown: Timer = $Cooldown
@onready var muzzle: Marker2D = $Muzzle

func _on_cooldown_timeout() -> void:
	is_ready = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	look_at(get_global_mouse_position())
	
	rotation_degrees = wrap(rotation_degrees,0,360)
	if rotation_degrees > 90 and rotation_degrees < 270:
		scale.y = -1
	else: 
		scale.y = 1
	
	if is_ready == true:
		var bullet_instance = BULLET.instantiate()
		get_tree().root.add_child(bullet_instance)
		bullet_instance.global_position = muzzle.global_position
		bullet_instance.rotation = rotation
		is_ready = false
		cooldown.start()
