extends HSlider

@onready var label=get_node("Label")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	max_value=GameState.get_player_money()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_value_changed(value: float) -> void:
	label.text="$"+str(int(value))
