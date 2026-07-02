extends Node2D

const CHIP_VALUES = {
	"gold": 5000,
	"black": 1000,
	"pink": 500,
	"green": 100,
	"purple": 25,
	"white": 10,
	"blue": 5,
	"red": 1
}
var amountLabel
var amount = 0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	render_chips(get_chip_representation(0))
	amountLabel=get_node("Label")
	
func render_chips(data):
	var this_sprite
	for color in data: 
		this_sprite=get_node(color)
		this_sprite.frame=data[color]

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
func get_chip_representation(amount: int) -> Dictionary:
	var chips = {}
	var remaining = amount

	for color in CHIP_VALUES:
		var value = CHIP_VALUES[color]

		var count = min(remaining / value, 4)
		count = int(count)

		chips[color] = count
		remaining -= count * value

	return chips

func set_amount(amount: int):
	amount=amount
	render_chips(get_chip_representation(amount))
	amountLabel.text="Pot: "+str(amount)
func get_amount()->int:
	return amount
func add_chips(number:int):
	var current = get_amount()
	set_amount(current+number)
