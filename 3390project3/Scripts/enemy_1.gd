extends CharacterBody2D

signal enemy_died(enemy)

var speed = 0
var damage = 0
var health = 0

var player = null

func _ready():
	player = get_tree().get_first_node_in_group("player")

func _physics_process(delta: float) -> void:
	velocity = (player.global_position - global_position).normalized() * speed
	
	move_and_slide()

func apply_damage(amount):
	health -= amount
	if health <= 0:
		die()

func die():
	emit_signal("enemy_died", self)
	queue_free()
