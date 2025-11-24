extends Node2D

const SPEED: int = 400

var attack_damage: int = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position += transform.x * SPEED * delta

func _on_disappear_timeout() -> void:
	queue_free()

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Enemies"):
		body.apply_damage(attack_damage)
		queue_free()
