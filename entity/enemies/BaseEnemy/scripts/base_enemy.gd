extends Area2D

# Base enemy properties
@export var move_speed: float = 50.0
@export var score_value: int = 100

func _get_score() -> int :
	return score_value
