extends Area2D


var game_startable=false
var player_body

var poker_game = preload("res://Scenes/poker.tscn")


func _on_area_entered(area: Area2D) -> void:
	if(area.is_in_group("player_collider")):
		player_body=area
		$Prompt.visible=true
		game_startable=true




func _on_area_exited(area: Area2D) -> void:
	game_startable=false
	$Prompt.visible=false
	

func _input(event: InputEvent) -> void:
	if(event.is_action("interact")&&game_startable==true):
		#store player position
		print(str(player_body.global_position.x))
		print(str(player_body.global_position.y))
		GameState.set_player_casino_position(player_body.global_position.x, player_body.global_position.y)
		#start game
		get_tree().change_scene_to_packed(poker_game)
		game_startable=false
