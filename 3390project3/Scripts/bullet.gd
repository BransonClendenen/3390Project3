extends Node2D

const SPEED: int = 400

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position += transform.x * SPEED * delta

func _on_disappear_timeout() -> void:
	queue_free()
