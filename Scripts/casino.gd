extends Node2D

func _on_player_area_entered(area: Area2D) -> void:
	area.get_node("Prompt").visible=true


func _on_player_area_exited(area: Area2D) -> void:
	area.get_node("Prompt").visible=false
