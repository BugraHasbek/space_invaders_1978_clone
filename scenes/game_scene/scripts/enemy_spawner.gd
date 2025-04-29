extends Node2D

@onready var enemies_container = $"../Enemies"  # Reference to the enemies holder
@export var enemy_scene: PackedScene  # Assign an enemy scene via the Inspector
@export var rows: int = 3
@export var columns: int = 20
@export var screen_fraction_top: float = 1.0 / 3.0  # Top third of the screen
@export var screen_margin_x: float = 1.0 / 10.0  # Margin from left/right
@export var screen_margin_y: float = 2.0 / 10.0  # Margin from top

signal enemy_died

func _process(delta: float) -> void:
	spawn_enemies()

func spawn_enemies():
	# Clear previous enemies
	if enemies_container.get_child_count() > 0:
		return  # Skip spawning if enemies exist

	var viewport_size = get_viewport_rect().size
	var screen_width = viewport_size.x
	var screen_height = viewport_size.y

	var row_spacing = (screen_height * screen_fraction_top) / rows
	var top_boundary = screen_margin_y * screen_height
	var left_boundary = screen_margin_x * screen_width
	var right_boundary = screen_width * (1.0 - screen_margin_x)
	var total_enemy_width = right_boundary - left_boundary
	var column_spacing = total_enemy_width / (columns - 1)

	for row in range(rows):
		for col in range(columns):
			var enemy_instance = enemy_scene.instantiate()
			enemy_instance.set_meta("grid_column", col)
			var spawn_x = left_boundary + (col * column_spacing)
			var spawn_y = top_boundary + row_spacing * row
			
			enemy_instance.position = Vector2(spawn_x, spawn_y)
			enemy_instance.connect("enemy_died", _on_enemy_died)
			enemies_container.add_child(enemy_instance)

func _on_enemy_died() -> void:
	emit_signal("enemy_died")
