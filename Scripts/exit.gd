extends Area2D




var game_startable=false


func _on_area_entered(area: Area2D) -> void:
	if(area.is_in_group("player_collider")):
		$Prompt.visible=true
		game_startable=true


func _on_area_exited(area: Area2D) -> void:
	game_startable=false
	$Prompt.visible=false
	

func _input(event: InputEvent) -> void:
	if game_startable and event.is_action_pressed("interact"):
		game_startable=false
		get_tree().change_scene_to_file("res://Scenes/game.tscn")
