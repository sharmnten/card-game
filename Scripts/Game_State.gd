extends Node


var playerMoney
var character_customization={
	"base":"light",
	"bottom":"blue",
	"eyes":"blue",
	"hair":"short_yellow",
	"top":"green"
}
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
	
#character customization stuff
func set_character(base, bottom, eyes, hair, top):
	character_customization["base"]=base
	character_customization["bottom"]=bottom
	character_customization["eyes"]=eyes
	character_customization["hair"]=hair
	character_customization["base"]=base
	
