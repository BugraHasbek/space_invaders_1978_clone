extends Node2D

func _ready() -> void:
	$World/Player.connect("player_died", _on_player_died)
	$World/EnemySpawner.connect("enemy_died", _on_enemy_died)

func _on_player_died() -> void:
	$HUD.player_died()
	
	if GameState.player_life_count <= 0:
		$HUD.display_game_over()

func _on_enemy_died(score_value: int) -> void:
	GameState.score += score_value
	$HUD.update_score()
