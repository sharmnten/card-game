extends Node


var playerMoney
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	playerMoney=1000


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
func get_player_money()-> int:
	return playerMoney
func set_player_money(amount: int):
	playerMoney=amount
	
