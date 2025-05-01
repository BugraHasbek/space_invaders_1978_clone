extends Area2D

const RELATIVE_HORIZONTAL_SPEED  : float = 0.5    # screen size per second

signal player_died
signal player_death_animation_finished

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@export var laser_scene: PackedScene


func _process(delta: float) -> void:
	if not GameState.is_game_running:
		return
	
	move_player(delta)
	
	if Input.is_action_just_pressed("fire"):
		fire_laser()

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
	
	var texture = sprite.sprite_frames.get_frame_texture(sprite.animation, sprite.frame)
	var sprite_width = texture.get_size().x * sprite.global_scale.x
	
	# Enforce screen boundaries
	var min_x = 0 + (sprite_width / 2)  # Adjust for player width
	var max_x = get_viewport_rect().size.x - (sprite_width / 2)  
	
	position.x = clamp(position.x, min_x, max_x)

func fire_laser() -> void:
	if not laser_scene:
		print("Error: Laser scene not assigned!")
		return

	# Instantiate laser instance
	var laser_instance = laser_scene.instantiate()
	
	var texture = sprite.sprite_frames.get_frame_texture(sprite.animation, sprite.frame)
	var sprite_size = texture.get_size() * sprite.scale

	# Position the laser at the top-center of the player
	laser_instance.position = position + Vector2(0, -sprite_size.y / 2)
	
	# Add laser instance to the current scene
	get_tree().current_scene.add_child(laser_instance)


func _on_area_entered(area: Area2D) -> void:
	# player collided with enemy ufo or player is hit by enemy fire
	if not area.is_in_group("player"):
		die()

func die() -> void:
	GameState.player_life_count -= 1
	sprite.play("death")
	emit_signal("player_died")

func _on_death_animation_finished() -> void:
	emit_signal("player_death_animation_finished")

func revive() -> void:
	sprite.stop()
	sprite.frame = 0
