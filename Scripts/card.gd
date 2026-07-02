extends Node2D

var suit
var value
var frame


func setup(cardSuit, cardValue)->void:
	suit=cardSuit
	value=cardValue
	frame=0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func get_suit()-> String:
	return suit
func get_value()-> String:
	return value
func get_card_data() -> Dictionary:
	return {
		"suit": suit,
		"rank": value
	}
	
func get_card_suit()->String:
	var card_data=get_card_data()
	return card_data["suit"]
func get_color()->String:
	if(get_card_suit()=="Hearts" or get_card_suit()=="Diamonds"):
		return "Red"
	elif(get_card_suit()=="Clubs" or get_card_suit()=="Spades"):
		return "Black"
	else:
		return ""
func set_frame(newFrame):
	frame=newFrame
func get_frame()->int:
	return frame
func get_rank_value() -> int:
	var values = {
		"A": 14,
		"2": 2,
		"3": 3,
		"4": 4,
		"5": 5,
		"6": 6,
		"7": 7,
		"8": 8,
		"9": 9,
		"10": 10,
		"J": 11,
		"Q": 12,
		"K": 13
	}
	return values[value]
