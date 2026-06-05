extends Node2D

var suit
var value


func setup(cardSuit, cardValue)->void:
	suit=cardSuit
	value=cardValue
	


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
