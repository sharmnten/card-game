extends Node2D


func _ready() -> void:
	print(GameState.use_player_pos)
	if(GameState.use_player_pos==true):
		$Player.position.x=GameState.player_x
		$Player.position.y=GameState.player_y
		print("x"+str(GameState.player_x))
		print("y"+str(GameState.player_y))
		GameState.reset_player_position()
	else:
		pass
