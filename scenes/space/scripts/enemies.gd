extends Node2D

enum MovementState { HORIZONTAL, VERTICAL }
var state: int = MovementState.HORIZONTAL

# Movement properties
var horizontal_direction: int = 1             # 1 to move right, -1 to move left.
@export var horizontal_speed: float = 100.0     # Horizontal speed in pixels per second.
@export var vertical_speed: float = 40.0        # Vertical speed (when moving down) in pixels per second.
@export var vertical_step: float = 20.0         # Fixed vertical displacement when a border is hit.
var pending_vertical_movement: float = 0.0      # How much vertical distance remains to move in vertical state.

# Attack properties
@export var ammo_scene: PackedScene             # Reference to the Ammo scene.
var attack_cooldown: float = 0.0
@export var min_attack_interval: float = 0.5      # Minimum seconds between shots.
@export var max_attack_interval: float = 2.0      # Maximum seconds between shots.
var attacks_this_phase: int = 0                  
@export var max_attacks_per_phase: int = 3        # Limited attacks during each horizontal phase.

func _process(delta: float) -> void:
	if get_child_count() == 0:
		return  # No enemy to move.
	
	match state:
		MovementState.HORIZONTAL:
			_move_horizontally(delta)
			_handle_attacks(delta)
		MovementState.VERTICAL:
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
		# Reset attack counter and cooldown after vertical movement
		attacks_this_phase = 0
		attack_cooldown = randf_range(min_attack_interval, max_attack_interval)

func _handle_attacks(delta: float) -> void:
	# Only allow attacks if we haven't reached the limit yet.
	if attacks_this_phase >= max_attacks_per_phase:
		return

	attack_cooldown -= delta
	if attack_cooldown <= 0:
		_attempt_attack()
		# Reset attack cooldown for next shot
		attack_cooldown = randf_range(min_attack_interval, max_attack_interval)

func _attempt_attack() -> void:
	# Determine the bottom-most enemy in each column by using a dictionary.
	var bottom_enemies = {}
	for enemy in get_children():
		var col = enemy.get_meta("grid_column")
		if not bottom_enemies.has(col) or enemy.position.y > bottom_enemies[col].position.y:
			bottom_enemies[col] = enemy

	var allowed_attackers = bottom_enemies.values()
	if allowed_attackers.size() == 0:
		return

	# Pick one randomly:
	var attacker = allowed_attackers[randi() % allowed_attackers.size()]
	_spawn_ammo_from(attacker)
	attacks_this_phase += 1

func _spawn_ammo_from(attacker: Node2D) -> void:
	# Instantiate Ammo and position it right below the enemy at its horizontal center.
	var ammo_instance = ammo_scene.instantiate()
	# To calculate proper placement, we assume the attacker has a AnimatedSprite2D child
	var sprite: AnimatedSprite2D = attacker.get_node("AnimatedSprite2D") as AnimatedSprite2D
	# Retrieve the current texture from the sprite's current animation and frame.
	var texture = sprite.sprite_frames.get_frame_texture(sprite.animation, sprite.frame)
	# Calculate the sprite size with scale taken into account.
	var sprite_size = texture.get_size() * sprite.scale
	ammo_instance.position = attacker.position + Vector2(0, sprite_size.y / 2)
	# Add the ammo to the current scene (or to a dedicated container for enemy projectiles)
	get_tree().current_scene.add_child(ammo_instance)
	
