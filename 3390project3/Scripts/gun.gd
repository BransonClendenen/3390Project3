extends Node2D

var is_ready: bool = true
const BULLET = preload("res://Scenes/Objects/Bullet.tscn")
@onready var cooldown: Timer = $Cooldown
@onready var muzzle: Marker2D = $Muzzle
@onready var player = get_parent()

var attack_damage
var attack_speed

func _ready():
	player.stats_changed.connect(_on_player_stats_changed)

func _on_player_stats_changed(dmg, spd):
	attack_damage = dmg
	attack_speed = spd

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
		#create bullet
		var bullet_instance = BULLET.instantiate()
		#set damage
		bullet_instance.attack_damage = attack_damage
		get_tree().root.add_child(bullet_instance)
		bullet_instance.global_position = muzzle.global_position
		bullet_instance.rotation = rotation
		#reset timer
		is_ready = false
		cooldown.start()
