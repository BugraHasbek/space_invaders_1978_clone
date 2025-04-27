extends Area2D

# Base enemy properties
@export var move_speed: float = 50.0
@export var score_value: int = 100

func move_enemy(delta: float) -> void:
	position.x += move_speed * delta  # Basic movement logic
