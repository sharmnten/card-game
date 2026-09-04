extends Area2D


var game_startable=false


var ride_the_bus_scene = preload("res://Scenes/ridethebus.tscn")


func _on_area_entered(area: Area2D) -> void:
	if(area.is_in_group("player_collider")):
		$Prompt.visible=true
		game_startable=true




func _on_area_exited(area: Area2D) -> void:
	game_startable=false
	$Prompt.visible=false
	

func _input(event: InputEvent) -> void:
	if(event.is_action("interact")):
		#start game
		get_tree().change_scene_to_packed(ride_the_bus_scene)
		game_startable=false
