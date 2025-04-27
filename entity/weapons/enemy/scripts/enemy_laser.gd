extends Area2D

@export var vertical_speed: float = 140.0        # Vertical speed in pixels per second.

func _process(delta: float) -> void:
	position.y += delta * vertical_speed
