extends CharacterBody2D

signal boss_died(enemy)

var speed = 0
var damage = 0
var health = 0

var player = null

func _ready():
	player = get_tree().get_first_node_in_group("Player")
	AudioManager.play_sfx("res://Sounds/boss_spawn.mp3",30)

func _physics_process(delta: float) -> void:
	velocity = (player.global_position - global_position).normalized() * speed
	
	move_and_slide()

func apply_damage(amount):
	health -= amount
	if health <= 0:
		die()

func die():
	emit_signal("boss_died", self)
	queue_free()
	AudioManager.play_sfx("res://Sounds/boss_dead.mp3",30)

func _on_attack_area_body_entered(body):
	if body.is_in_group("Player"):
		#print("Player entered attack range")
		body.apply_damage(damage)
