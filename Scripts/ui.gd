extends Control


func _ready() -> void:
	$Money.text="$"+str(GameState.get_player_money())
