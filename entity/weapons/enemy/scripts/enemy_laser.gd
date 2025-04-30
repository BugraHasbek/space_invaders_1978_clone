extends Area2D

@export var vertical_speed: float = 140.0        # Vertical speed in pixels per second.

func _process(delta: float) -> void:
	if(GameState.is_game_running):
		position.y += delta * vertical_speed

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("player") or area.is_in_group("boundary"):
		self.queue_free()
