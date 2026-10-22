extends Node2D


func _ready() -> void:
	print(GameState.use_player_casino_pos)
	if(GameState.use_player_casino_pos==true):
		$CharacterBody2D.global_position=GameState.get_player_casino_position()
		GameState.reset_player_casino_position()
	else:
		pass
