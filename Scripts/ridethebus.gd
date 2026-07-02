extends Node2D

@onready var deck_sprite=get_node("CardPlaceholders/Deck")
@onready var community_card_1=get_node("CardPlaceholders/Community")
@onready var community_card_2=get_node("CardPlaceholders/Community2")
@onready var community_card_3=get_node("CardPlaceholders/Community3")
@onready var community_card_4=get_node("CardPlaceholders/Community4")
@onready var dealer_card_1=get_node("CardPlaceholders/DealerCard")
@onready var dealer_card_2=get_node("CardPlaceholders/DealerCard1")
@onready var check_button=get_node("Check Button")
@onready var fold_button=get_node("Fold Button")
@onready var raise_button=get_node("Raise Button")
@onready var player_money=get_node("UI/PlayerMoney")
@onready var bet_amount=get_node("UI/GameStart/BetSlider")
@onready var start_button=get_node("UI/GameStart/StartButton")
@onready var back_button=get_node("UI/GameStart/BackButton")
@onready var turn1=get_node("UI/Turn1")
@onready var turn2=get_node("UI/Turn2")
@onready var turn3=get_node("UI/Turn3")
@onready var turn4=get_node("UI/Turn4")
@onready var pot_label=get_node("UI/Pot Label")
@onready var chip=get_node("chips")
@onready var instructions=get_node("UI/Instruction")
@onready var exit_button=get_node("UI//Exit")

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
var player_hand=[]
var house_hand=[]
var community_cards=[]

#Preload card scene
var CardScene = preload("res://Scenes/card.tscn")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player_money.text="$"+str(GameState.get_player_money())
	#Set default animation states for all card placeholders in the game
	deck_sprite.frame=0
	community_card_1.frame=54
	community_card_2.frame=54
	community_card_3.frame=54
	community_card_4.frame=54
	#Start game logic setup
	shuffle()

	
	



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass







func shuffle() -> void:
	deck.shuffle()

func deal() -> Dictionary:
	return deck.pop_back()
func flip_card(card)->Node2D:
	var newCard=card
	var cardData=newCard.get_card_data()
	var animationIndex=0
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
	"K": 13,}
	print(cardData)
	var frame = animationIndex + int(rank_offsets[cardData["rank"]])
	card.set_frame(frame)
	return card


func render_deck_card(cardData) -> Node2D:
	var newCard = CardScene.instantiate()

	newCard.setup(cardData["suit"], cardData["rank"])

	rendered_cards.append(newCard)
	newCard.position = Vector2(383.5, 324)
	newCard.get_node("AnimatedSprite2D").frame = 0

	add_child(newCard)

	return newCard





func render_flip_card(card):
	var tween = create_tween()

	tween.tween_property(card, "scale:x", 0.0, 0.15)

	tween.tween_callback(func():
		card.get_node("AnimatedSprite2D").frame=card.get_frame()
	)

	tween.tween_property(card, "scale:x", 1.5, 0.15)

var bet
func _on_start_button_pressed() -> void:
	bet_amount.visible=false
	back_button.visible=false
	start_button.visible=false
	turn1.visible=true
	instructions.visible=true
	var player_money_value=GameState.get_player_money()
	bet=bet_amount.value
	chip.set_amount(bet)
	player_money_value=player_money_value-bet
	GameState.set_player_money(player_money_value)
	player_money.text="$"+str(int(player_money_value))
	

func deal_next_card() -> Node2D: 
	var card_x=[460.5, 537.5, 614.5, 691.5, 768.5]
	var card_data = deal()
	var card= render_deck_card(card_data)
	var tween = create_tween()
	tween.tween_property(card, "position", Vector2(card_x[rendered_cards.size()-1], 324.0), 0.5)
	await tween.finished
	render_flip_card(flip_card(card))
	return card
	


func _on_red_button_pressed() -> void:
	turn1.visible=false
	var card= await deal_next_card()
	if(card.get_color()=="Red"):
		higher_lower_setup()
	else:
		print("You Lose")
		game_over()
	
	
func _on_black_button_pressed() -> void:
	turn1.visible=false
	var card= await deal_next_card()
	if(card.get_color()=="Black"):
		higher_lower_setup()
		
	else:
		print("You Lose")
		game_over()

func higher_lower_setup():
	instructions.text="Guess higher or lower to triple the pot"
	chip.set_amount(bet*2)
	bet=bet*2
	turn2.visible=true
	exit_button.visible=true
func game_over():
	instructions.text="Game Over!"
	exit_button.visible=false
	

func _on_exit_pressed() -> int:
	var playerMoney=GameState.get_player_money()+bet
	GameState.set_player_money(playerMoney)
	return GameState.get_player_money()

func game_win()->void:
	var money = _on_exit_pressed()
	instructions.text="You won $"+str(money)+"!"


func _on_higher_pressed() -> void:
	deal_next_card()
	var card1=rendered_cards[0]
	var card2=rendered_cards[1]
	if(card1.get_rank_value()<=card2.get_rank_value()):
		setup_inside_outside()
	else:
		game_over()
		print("You Lose")

func _on_lower_pressed() -> void:
	deal_next_card()
	var card1=rendered_cards[0]
	var card2=rendered_cards[1]
	if(card1.get_rank_value()>=card2.get_rank_value()):
		setup_inside_outside()
	else:
		game_over()
		print("You Lose")

func setup_inside_outside():
	instructions.text="Guess if the next card will be inside or outside to quadruple the pot"
	chip.set_amount(bet*1.5)
	bet=bet*1.5
	turn2.visible=false
	turn3.visible=true

func setup_suit():
	turn3.visible=false
	turn4.visible=true
	instructions.text="Guess the suit of the final card to 20x the pot"
	
	
	


func _on_inside_pressed() -> void:
	var firstCard=rendered_cards[0]
	var secondCard=rendered_cards[1]
	var thirdCard=await deal_next_card()
	var lowerBound=min(firstCard.get_rank_value(), secondCard.get_rank_value())
	var upperBound=max(firstCard.get_rank_value(), secondCard.get_rank_value())
	if(thirdCard.get_rank_value()>=lowerBound and thirdCard.get_rank_value()<=upperBound):
		setup_suit()
	else:
		game_over()
	


func _on_outside_pressed() -> void:
	var firstCard=rendered_cards[0]
	var secondCard=rendered_cards[1]
	var thirdCard=await deal_next_card()
	var lowerBound=min(firstCard.get_rank_value(), secondCard.get_rank_value())
	var upperBound=max(firstCard.get_rank_value(), secondCard.get_rank_value())
	if(thirdCard.get_rank_value()<=lowerBound or thirdCard.get_rank_value()>=upperBound):
		setup_suit()
	else:
		game_over()
		


func _on_spades_button_down() -> void:
	var fourthCard=await deal_next_card()
	if fourthCard.get_suit()=="Spades":
		game_win()
	else:
		game_over()

func _on_clubs_button_down() -> void:
	var fourthCard=await deal_next_card()
	if(fourthCard.get_suit()=="Clubs"):
		game_win()
	else:
		game_over()

func _on_hearts_button_down() -> void:
	var fourthCard=await deal_next_card()
	if(fourthCard.get_suit()=="Hearts"):
		game_win()
	else:
		game_over()

func _on_diamonds_button_down() -> void:
	var fourthCard=await deal_next_card()
	if(fourthCard.get_suit()=="Diamonds"):
		game_win()
	else:
		game_over()
