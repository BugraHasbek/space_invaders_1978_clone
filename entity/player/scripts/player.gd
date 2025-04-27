extends Area2D

const RELATIVE_HORIZONTAL_SPEED  : float = 0.5    # screen size per second

@onready var sprite = $Sprite2D

func _process(delta: float) -> void:
	move_player(delta)

## Moves the player horizontally based on player input.
## 
## Args:
## delta (float): The time elapsed since the last frame.
func move_player(delta: float) -> void:
	var horizontal_displacement:float  = 0.0
	var absolute_horizontal_speed = RELATIVE_HORIZONTAL_SPEED * get_viewport_rect().size.x
	
	# move left or right
	if Input.is_action_pressed("left"):
		horizontal_displacement = delta * absolute_horizontal_speed * -1.0 
	elif Input.is_action_pressed("right"):
		horizontal_displacement = delta * absolute_horizontal_speed
	
	# Apply movement
	position.x += horizontal_displacement
	
	var sprite_width = sprite.get_rect().size.x * sprite.global_scale.x
	
	# Enforce screen boundaries
	var min_x = 0 + (sprite_width / 2)  # Adjust for player width
	var max_x = get_viewport_rect().size.x - (sprite_width / 2)  
	
	position.x = clamp(position.x, min_x, max_x)
