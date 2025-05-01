extends Area2D

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

var max_health:int = 2
var health: int = max_health

func _on_area_entered(area: Area2D) -> void:
	health -= 1
	
	if (health <= 0):
		queue_free()
	else:
		sprite.frame = max_health - health
	
	
