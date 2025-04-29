extends "res://entity/enemies/BaseEnemy/scripts/base_enemy.gd"

func _ready() -> void:
	score_value = 10

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("player") or area.is_in_group("boundary"):
		super.die()
