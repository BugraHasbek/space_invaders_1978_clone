extends Node2D

func _ready() -> void:
	$World/Player.connect("player_died", _on_player_died)
	$World/Player.connect("player_death_animation_finished", _on_player_death_animation_finished)
	$World/EnemySpawner.connect("enemy_died", _on_enemy_died)

func _on_player_died() -> void:
	# stop game loop (moving and firing)
	GameState.is_game_running = false
	
	# remove a life icon from HUD
	$HUD.update_lives_display()
	
	## all lives are spent. Game over!
	if GameState.player_life_count <= 0:
		# update max score
		if(GameState.score > GameState.max_score):
			GameState.max_score = GameState.score
		
		$HUD.display_game_over()

func _on_player_death_animation_finished() -> void:
	if GameState.player_life_count > 0:
		GameState.is_game_running = true
		$World/Player.revive()

func _on_enemy_died(score_value: int) -> void:
	GameState.score += score_value
	$HUD.update_score()
