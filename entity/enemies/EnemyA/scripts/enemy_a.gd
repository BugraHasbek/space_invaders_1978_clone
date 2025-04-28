extends "res://entity/enemies/BaseEnemy/scripts/base_enemy.gd"

signal enemy_died

func _ready() -> void:
	score_value = 150

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("player") or area.is_in_group("boundary"):
		emit_signal("enemy_died")
		self.queue_free()
