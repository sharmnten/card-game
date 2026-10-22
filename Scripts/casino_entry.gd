extends Area2D

var teleportable=false
var player_body
func _on_area_entered(area: Area2D) -> void:
	$"../Prompt".visible=true
	player_body=area
	if(area.is_in_group('player_collider')):
		teleportable=true
func _on_area_exited(area: Area2D) -> void:
	$"../Prompt".visible=false
	if(area.is_in_group('player_collider')):
		teleportable=false

func _input(event: InputEvent) -> void:
	if teleportable and event.is_action_pressed("interact"):
		GameState.set_player_game_position(player_body.global_position.x, player_body.global_position.y)
		teleportable=false
		get_tree().change_scene_to_file("res://Scenes/casino.tscn")
