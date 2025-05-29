extends "res://entity/skyline/BaseLandmark/scripts/base_landmark.gd"

func _ready() -> void:
	max_health = 5
	health = max_health

func _on_area_entered(area: Area2D) -> void:
	super._on_area_entered(area)
