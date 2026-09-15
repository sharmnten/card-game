extends Node


var playerMoney
var character_customization={
	"base":0,
	"bottom":0,
	"eyes":0,
	"hair":0,
	"top":0
}
var use_player_pos=false
var player_x
var player_y
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
func set_player_position(x: float, y: float):
	print("saved pos")
	use_player_pos=true
	player_x=x
	player_y=y
func get_player_position() -> Vector2:
	return Vector2(player_x, player_y)
func reset_player_position():
	use_player_pos=false
	player_x=0
	player_y=0
#character customization stuff
func set_character(base, bottom, eyes, hair, top):
	character_customization["base"]=base
	character_customization["bottom"]=bottom
	character_customization["eyes"]=eyes
	character_customization["hair"]=hair
	character_customization["top"]=top
	
func get_character()->Dictionary:
	return character_customization
