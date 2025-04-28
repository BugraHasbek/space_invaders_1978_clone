extends Area2D

@export var vertical_speed: float = 140.0        # Vertical speed in pixels per second.

func _process(delta: float) -> void:
	position.y -= delta * vertical_speed


func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("enemy") or area.is_in_group("boundary"):
		#await get_tree().process_frame  # Ensure signals execute before freeing
		self.queue_free()
