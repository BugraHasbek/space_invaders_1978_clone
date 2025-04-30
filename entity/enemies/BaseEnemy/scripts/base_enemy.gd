extends Area2D

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

signal enemy_died

# Base enemy properties
@export var move_speed: float = 50.0
@export var score_value: int = 0  # Base score, overridden in child classes

var is_dying: bool = false  # Flag to prevent repeated death logic

func _get_score() -> int :
	return score_value

func die():
	if is_dying:
		return  # Prevent duplicate calls
	is_dying = true  # Mark as dying to prevent multiple triggers
	
	disconnect("area_entered", _on_area_entered)  # Unsubscribe from further collisions
	
	sprite.stop()
	sprite.play("death")
	sprite.connect("animation_finished", _on_death_animation_finished)
	emit_signal("enemy_died", score_value)  # Emit the score value when destroyed
	
func _on_death_animation_finished() -> void:
	queue_free()

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("player") or area.is_in_group("boundary"):
		die()
