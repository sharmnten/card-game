extends Node2D
@onready var player_card_one=get_node("CardPlaceholders/PlayerCard")
@onready var player_card_two=get_node("CardPlaceholders/PlayerCard2")
@onready var deck_sprite=get_node("CardPlaceholders/Deck")
@onready var community_card_1=get_node("CardPlaceholders/Community")
@onready var community_card_2=get_node("CardPlaceholders/Community2")
@onready var community_card_3=get_node("CardPlaceholders/Community3")
@onready var community_card_4=get_node("CardPlaceholders/Community4")
@onready var community_card_5=get_node("CardPlaceholders/Community5")
@onready var dealer_card_1=get_node("CardPlaceholders/DealerCard")
@onready var dealer_card_2=get_node("CardPlaceholders/DealerCard1")
@onready var check_button=get_node("Check Button")
@onready var fold_button=get_node("Fold Button")
@onready var raise_button=get_node("Raise Button")
var rendered_cards=[]
var deck = [
	{"suit":"Hearts", "rank":"A"},
	{"suit":"Hearts", "rank":"2"},
	{"suit":"Hearts", "rank":"3"},
	{"suit":"Hearts", "rank":"4"},
	{"suit":"Hearts", "rank":"5"},
	{"suit":"Hearts", "rank":"6"},
	{"suit":"Hearts", "rank":"7"},
	{"suit":"Hearts", "rank":"8"},
	{"suit":"Hearts", "rank":"9"},
	{"suit":"Hearts", "rank":"10"},
	{"suit":"Hearts", "rank":"J"},
	{"suit":"Hearts", "rank":"Q"},
	{"suit":"Hearts", "rank":"K"},

	{"suit":"Diamonds", "rank":"A"},
	{"suit":"Diamonds", "rank":"2"},
	{"suit":"Diamonds", "rank":"3"},
	{"suit":"Diamonds", "rank":"4"},
	{"suit":"Diamonds", "rank":"5"},
	{"suit":"Diamonds", "rank":"6"},
	{"suit":"Diamonds", "rank":"7"},
	{"suit":"Diamonds", "rank":"8"},
	{"suit":"Diamonds", "rank":"9"},
	{"suit":"Diamonds", "rank":"10"},
	{"suit":"Diamonds", "rank":"J"},
	{"suit":"Diamonds", "rank":"Q"},
	{"suit":"Diamonds", "rank":"K"},

	{"suit":"Clubs", "rank":"A"},
	{"suit":"Clubs", "rank":"2"},
	{"suit":"Clubs", "rank":"3"},
	{"suit":"Clubs", "rank":"4"},
	{"suit":"Clubs", "rank":"5"},
	{"suit":"Clubs", "rank":"6"},
	{"suit":"Clubs", "rank":"7"},
	{"suit":"Clubs", "rank":"8"},
	{"suit":"Clubs", "rank":"9"},
	{"suit":"Clubs", "rank":"10"},
	{"suit":"Clubs", "rank":"J"},
	{"suit":"Clubs", "rank":"Q"},
	{"suit":"Clubs", "rank":"K"},

	{"suit":"Spades", "rank":"A"},
	{"suit":"Spades", "rank":"2"},
	{"suit":"Spades", "rank":"3"},
	{"suit":"Spades", "rank":"4"},
	{"suit":"Spades", "rank":"5"},
	{"suit":"Spades", "rank":"6"},
	{"suit":"Spades", "rank":"7"},
	{"suit":"Spades", "rank":"8"},
	{"suit":"Spades", "rank":"9"},
	{"suit":"Spades", "rank":"10"},
	{"suit":"Spades", "rank":"J"},
	{"suit":"Spades", "rank":"Q"},
	{"suit":"Spades", "rank":"K"}
]

#Preload card scene
var CardScene = preload("res://Scenes/card.tscn")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#Set default animation states for all card placeholders in the game
	player_card_one.frame=54
	player_card_two.frame=54
	deck_sprite.frame=0
	community_card_1.frame=54
	community_card_2.frame=54
	community_card_3.frame=54
	community_card_4.frame=54
	community_card_5.frame=54
	dealer_card_1.frame=54
	dealer_card_2.frame=54
	#Start game logic setup
	shuffle()
	



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass







func shuffle() -> void:
	deck.shuffle()

func deal() -> Dictionary:
	return deck.pop_back()
func render_deck_card(cardData)->Node2D:
	var newCard = CardScene.instantiate()
	var animationIndex=0
	print(cardData)
	if(cardData["suit"]=="Diamonds"):
		animationIndex=13
	elif(cardData["suit"]=="Spades"):
		animationIndex=26
	elif(cardData["suit"]=="Clubs"):
		animationIndex=39
	var rank_offsets = {
	"A": 1,
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
	var frame = animationIndex + int(rank_offsets[cardData["rank"]])
	
	rendered_cards.append(newCard)
	newCard.position=Vector2(383.5,324)
	newCard.get_node("AnimatedSprite2D").frame=frame
	add_child(newCard)
	
	return newCard

func deal_to_player(cardSpot):
	var playerCard = render_deck_card(deal())
	var tween = create_tween()
	if(cardSpot==1):
		tween.tween_property(playerCard, "position", Vector2(537.5, 549), 0.5)
	elif(cardSpot==2):
		tween.tween_property(playerCard, "position", Vector2(614.5, 549.0), 0.5)



func _on_check_button_pressed() -> void:
	deal_to_player(1)



func _on_fold_button_pressed() -> void:
	print("fold button pressed")



func _on_raise_button_pressed() -> void:
	print("raise button pressed")
