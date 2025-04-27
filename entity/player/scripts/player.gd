extends Area2D

const RELATIVE_HORIZONTAL_SPEED  : float = 0.5    # screen size per second

func _process(delta: float) -> void:
	move_player(delta)

## Moves the player horizontally and vertically (always moves upward) based on player input.
## Also updates speed-related UI elements.
## 
## Args:
## delta (float): The time elapsed since the last frame.
func move_player(delta: float) -> void:
	var horizontal_displacement:float  = 0.0
	var absolute_horizontal_speed = RELATIVE_HORIZONTAL_SPEED * DisplayServer.screen_get_size().x
	
	# move left or right
	if Input.is_action_pressed("left"):
		horizontal_displacement = delta * absolute_horizontal_speed * -1.0 
		position.x += horizontal_displacement
	elif Input.is_action_pressed("right"):
		horizontal_displacement = delta * absolute_horizontal_speed
		position.x += horizontal_displacement
	
