extends Node


var playerMoney
var character_customization={
	"base":0,
	"bottom":0,
	"eyes":0,
	"hair":0,
	"top":0
}
var use_player_casino_pos=false
var use_player_game_pos=false
var player_casino_x
var player_casino_y
var player_game_x
var player_game_y
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
func set_player_casino_position(x: float, y: float):
	print("saved pos")
	use_player_casino_pos=true
	player_casino_x=x
	player_casino_y=y
func get_player_casino_position() -> Vector2:
	return Vector2(player_casino_x, player_casino_y)
func reset_player_casino_position():
	use_player_casino_pos=false
	player_casino_x=0
	player_casino_y=0
	
func set_player_game_position(x: float, y: float):
	print("saved pos")
	use_player_game_pos=true
	player_game_x=x
	player_game_y=y
func get_player_game_position() -> Vector2:
	return Vector2(player_game_x, player_game_y)
func reset_player_game_position():
	use_player_game_pos=false
	player_game_x=0
	player_game_y=0
#character customization stuff
func set_character(base, bottom, eyes, hair, top):
	character_customization["base"]=base
	character_customization["bottom"]=bottom
	character_customization["eyes"]=eyes
	character_customization["hair"]=hair
	character_customization["top"]=top
	
func get_character()->Dictionary:
	return character_customization
