extends CharacterBody2D

const SPEED = 150.0

var player = null

func _ready():
	player = get_parent().get_node("Player")

func _physics_process(delta: float) -> void:
	velocity = (player.global_position - global_position).normalized() * SPEED
	
	look_at(player.global_position)
	
	move_and_slide()
	
