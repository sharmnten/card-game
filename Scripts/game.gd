extends Node2D


func _ready() -> void:
	if(GameState.use_player_game_pos==true):
		$CharacterBody2D.global_position=GameState.get_player_game_position()
		GameState.reset_player_game_position()
	else:
		pass
