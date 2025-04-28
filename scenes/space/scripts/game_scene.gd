extends Node2D

func _ready() -> void:
	$World/Player.connect("player_died", _on_player_died)

func _on_player_died() -> void:
	$HUD.display_game_over()
