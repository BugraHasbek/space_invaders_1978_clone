extends Area2D

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

signal enemy_died

# Base enemy properties
@export var move_speed: float = 50.0
@export var score_value: int = 0  # Base score, overridden in child classes

func _get_score() -> int :
	return score_value

func die():
	sprite.stop()
	sprite.play("death")
	sprite.connect("animation_finished", _on_death_animation_finished)
	emit_signal("enemy_died", score_value)  # Emit the score value when destroyed
	
func _on_death_animation_finished() -> void:
	queue_free()
