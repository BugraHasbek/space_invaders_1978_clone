extends Node2D

@export var life_icon_scene: PackedScene  # Assign the Sprite2D scene in the Inspector
@export var life_spacing: float = 40.0    # Adjust spacing between life icons
var life_sprites = []

func _ready() -> void:
	update_lives_display()

func update_lives_display() -> void:
	var life_count = GameState.player_life_count
	
	# Clear existing sprites
	for sprite in life_sprites:
		sprite.queue_free()
	life_sprites.clear()

	var screen_height = get_viewport_rect().size.y
	var screen_width = get_viewport_rect().size.x
	var bottom_margin = screen_height * 0.95  # Bottom 1/10 of the screen
	var left_margin = screen_width * 0.1
	
	# Create life icons based on player_life_count
	for i in range(life_count):
		var life_sprite = life_icon_scene.instantiate()
		life_sprite.position = Vector2(left_margin + i * life_spacing, bottom_margin)  # Positioning horizontally
		add_child(life_sprite)
		life_sprites.append(life_sprite)
