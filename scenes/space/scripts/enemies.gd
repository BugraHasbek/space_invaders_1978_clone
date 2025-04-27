extends Node2D

enum MovementState { HORIZONTAL, VERTICAL }
var state: int = MovementState.HORIZONTAL

var horizontal_direction: int = 1             # 1 to move right, -1 to move left.
@export var horizontal_speed: float = 100.0     # Horizontal speed in pixels per second.
@export var vertical_speed: float = 40.0        # Vertical speed (when moving down) in pixels per second.
@export var vertical_step: float = 20.0         # Fixed vertical displacement when a border is hit.

var pending_vertical_movement: float = 0.0      # How much vertical distance remains to move in vertical state.

func _process(delta: float) -> void:
	if get_child_count() == 0:
		return  # No enemy to move.
	
	match state:
		MovementState.HORIZONTAL:
			print('Moving horizontally')
			_move_horizontally(delta)
		MovementState.VERTICAL:
			print('Moving Vertically')
			_move_vertically(delta)

func _move_horizontally(delta: float) -> void:
	# Calculate the horizontal displacement.
	var dx: float = horizontal_speed * delta * horizontal_direction

	# Move every enemy in the container.
	for enemy in get_children():
		enemy.position.x += dx

	# Define horizontal boundaries using viewport size.
	var viewport_size = get_viewport_rect().size
	var left_bound: float = viewport_size.x * 0.05  # 5% from left
	var right_bound: float = viewport_size.x * 0.95   # 5% from right

	# Determine if one of the enemies reaches the boundary.
	if horizontal_direction > 0:
		var rightmost: float = -INF
		for enemy in get_children():
			rightmost = max(rightmost, enemy.position.x)
		if rightmost >= right_bound:
			state = MovementState.VERTICAL
			pending_vertical_movement = vertical_step
	else:
		var leftmost: float = INF
		for enemy in get_children():
			leftmost = min(leftmost, enemy.position.x)
		if leftmost <= left_bound:
			state = MovementState.VERTICAL
			pending_vertical_movement = vertical_step

func _move_vertically(delta: float) -> void:
	# Calculate vertical movement ensuring we don't overshoot.
	var dy: float = vertical_speed * delta
	if dy > pending_vertical_movement:
		dy = pending_vertical_movement

	# Move every enemy down.
	for enemy in get_children():
		enemy.position.y += dy

	pending_vertical_movement -= dy
	if pending_vertical_movement <= 0:
		# Finished moving downward—resume horizontal movement in the opposite direction.
		state = MovementState.HORIZONTAL
		horizontal_direction *= -1
