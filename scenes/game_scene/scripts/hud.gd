extends CanvasLayer

func display_game_over() -> void:
	$GameOverLabel.visible = true
	$MaxScoreLabel.update_score()

func player_died() -> void:
	$LivesContainer.update_lives_display()

func hide_game_over() -> void:
	$GameOverLabel.visible = false

func update_score() -> void:
	$ScoreLabel.update_score()
