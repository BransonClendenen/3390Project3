extends Area2D

@export var item_type: String
@export var value: int = 1

signal picked_up

func _ready():
	connect("body_entered", _on_body_entered)

func _on_body_entered(body):
	if body.is_in_group("Player"):
		emit_signal("picked_up", body)
		queue_free()
