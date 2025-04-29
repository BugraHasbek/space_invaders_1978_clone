extends CanvasLayer

func display_game_over() -> void:
	$GameOverLabel.visible = true

func player_died() -> void:
	$LivesContainer.update_lives_display()

func hide_game_over() -> void:
	$GameOverLabel.visible = false
