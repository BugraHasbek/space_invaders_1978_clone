extends CanvasLayer

func display_game_over() -> void:
	$GameOverLabel.visible = true

func hide_game_over() -> void:
	$GameOverLabel.visible = false
