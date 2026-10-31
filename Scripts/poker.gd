
extends Node2D

var card_scene = preload("res://Scenes/card.tscn")
var ante = 5
var suits = ["Hearts", "Diamonds", "Clubs", "Spades"]
var values = ["A", "2", "3", "4", "5", "6", "7", "8", "9", "10", "J", "Q", "K"]
var deck_position = Vector2(383.5, 324.0)
var board_x = [460.5, 537.5, 614.5, 691.5, 768.5]
var board_y = 324.0

@onready var player_money_label = $UI/PlayerMoney
@onready var chips_asset = $chips
@onready var bet_amount = $UI/BetAmount
@onready var start_ui = $UI/Start
@onready var game_ui = $UI/Game
@onready var end_ui = $UI/End
@onready var raise_button = $"UI/Game/Raise Button"
@onready var status_label = $"UI/Poker Status"
@onready var pot_label = $"UI/Poker Pot"
@onready var result_label = $"UI/End/PanelContainer/MarginContainer/VBoxContainer/Label"
@onready var result_details_label = $"UI/End/PanelContainer/MarginContainer/VBoxContainer/Details Label"
@onready var replay_button = $"UI/End/PanelContainer/MarginContainer/VBoxContainer/Replay Button"

var deck=[]
var player_hand=[]
var house_hand=[]
var community_cards=[]

var deal_state="ready"
var round_busy=false
var raised_once=false
var pot=0
var player_paid=0


func _ready() -> void:
	for name in ["PlayerCard", "PlayerCard2", "Community", "Community2", "Community3", "Community4", "Community5", "DealerCard", "DealerCard1"]:
		var holder = get_node_or_null("CardPlaceholders/" + name)
		if holder != null:
			holder.set("frame", 54)

	var deck_holder = get_node_or_null("CardPlaceholders/Deck")
	if deck_holder != null:
		deck_holder.set("frame", 0)

	start_ui.show()
	game_ui.hide()
	end_ui.hide()
	bet_amount.hide()
	bet_amount.step = 1.0
	bet_amount.min_value = 0.0
	chips_asset.set_amount(0)
	create_deck()
	refresh_money_label()
	refresh_table_labels("Press Start to play. Each hand costs $"+str(ante))
	replay_button.text = "Play Again ($"+str(ante)+")"


func create_deck() -> void:
	deck.clear()
	for suit in suits:
		for value in values:
			deck.append({"suit": suit, "rank": value})
	deck.shuffle()


func deal() -> Dictionary:
	return deck.pop_back()


func refresh_money_label() -> void:
	player_money_label.text = "$" + str(GameState.get_player_money())


func refresh_table_labels(message: String) -> void:
	status_label.text = message
	pot_label.text = "Pot:$"+str(pot)
	refresh_money_label()


func subtract_from_player(amount: int) -> void:
	GameState.set_player_money(GameState.get_player_money() - amount)
	refresh_money_label()


func render_deck_card(card_data: Dictionary) -> Node2D:
	var card = card_scene.instantiate()
	card.setup(card_data["suit"], card_data["rank"])
	card.position = deck_position
	add_child(card)
	card.get_node("AnimatedSprite2D").frame = 0
	return card


func flip_card(card: Node2D) -> Node2D:
	var card_data = card.get_card_data()
	var suit_offset = {"Hearts": 0, "Diamonds": 13, "Spades": 26, "Clubs": 39}
	var rank_offset = {"A": 1, "2": 2, "3": 3, "4": 4, "5": 5, "6": 6, "7": 7, "8": 8, "9": 9, "10": 10, "J": 11, "Q": 12, "K": 13}
	card.set_frame(suit_offset[card_data["suit"]] + rank_offset[card_data["rank"]])
	return card


func render_flip_card(card: Node2D) -> void:
	var tween = create_tween()
	tween.tween_property(card, "scale:x", 0.0, 0.15)
	tween.tween_callback(func(): card.get_node("AnimatedSprite2D").frame = card.get_frame())
	tween.tween_property(card, "scale:x", 1.5, 0.15)
	await tween.finished


func move_new_card(destination: Vector2, show_face: bool) -> Node2D:
	var card = render_deck_card(deal())
	var tween = create_tween()
	tween.tween_property(card, "position", destination, 0.35)
	await tween.finished
	if show_face:
		await render_flip_card(flip_card(card))
	return card


func deal_to_player() -> void:
	var index = player_hand.size()
	var destination = Vector2(537.5 + 77.0 * index, 549.0)
	var card = await move_new_card(destination, true)
	player_hand.append(card)


func deal_to_house() -> void:
	var index = house_hand.size()
	var destination = Vector2(537.5 + 77.0 * index, 132.0)
	var card = await move_new_card(destination, false)
	house_hand.append(card)


func deal_board_card(index: int) -> void:
	var destination = Vector2(board_x[index], board_y)
	var card = await move_new_card(destination, true)
	community_cards.append(card)


func deal_flop() -> void:
	for index in range(3):
		await deal_board_card(index)


func deal_turn() -> void:
	await deal_board_card(3)


func deal_river() -> void:
	await deal_board_card(4)


func reveal_dealer_hand() -> void:
	for card in house_hand:
		await render_flip_card(flip_card(card))


func _on_start_button_pressed() -> void:
	if round_busy or deal_state not in ["ready", "finished"]:
		return
	if GameState.get_player_money() < ante:
		start_ui.show()
		end_ui.hide()
		refresh_table_labels("You need $"+str(ante)+" to play another hand.")
		return

	round_busy = true
	start_ui.hide()
	game_ui.hide()
	deal_state = "preflop"

	subtract_from_player(ante)
	player_paid = ante
	pot = 2 * ante
	chips_asset.set_amount(pot)
	refresh_table_labels("Dealing cards...")

	await deal_to_player()
	await deal_to_house()
	await deal_to_player()
	await deal_to_house()

	round_busy = false
	game_ui.show()
	refresh_table_labels("Preflop: Check, Raise, or Fold")


func deal_next() -> void:
	if round_busy or deal_state not in ["preflop", "flop", "turn", "river"]:
		return
	round_busy = true
	game_ui.hide()
	bet_amount.hide()
	raised_once = false
	raise_button.text = "Raise"

	match deal_state:
		"preflop":
			refresh_table_labels("Dealing the flop...")
			await deal_flop()
			deal_state = "flop"
		"flop":
			refresh_table_labels("Dealing the turn...")
			await deal_turn()
			deal_state = "turn"
		"turn":
			refresh_table_labels("Dealing the river...")
			await deal_river()
			deal_state = "river"
		"river":
			await game_over("river")
			return

	round_busy = false
	game_ui.show()
	refresh_table_labels(deal_state.capitalize() + ": Check, Raise, or Fold")


func _on_check_button_pressed() -> void:
	if round_busy or raised_once:
		return
	await deal_next()


func _on_raise_button_pressed() -> void:
	if round_busy or deal_state not in ["preflop", "flop", "turn", "river"]:
		return

	var balance = int(GameState.get_player_money())
	if not raised_once:
		if balance <= 0:
			refresh_table_labels("Not enough chips to raise. You can check or fold.")
			return
		raised_once = true
		bet_amount.min_value = 1.0
		bet_amount.max_value = float(balance)
		bet_amount.step = 1.0
		bet_amount.value = 1.0
		bet_amount.show()
		raise_button.text = "Confirm Raise"
		refresh_table_labels("Choose raise amount with the slider, then confirm.")
		return

	var additional_bet = clampi(int(round(bet_amount.value)), 1, balance)
	subtract_from_player(additional_bet)
	player_paid += additional_bet
	pot += additional_bet * 2
	chips_asset.set_amount(pot)
	raised_once = false
	raise_button.text = "Raise"
	bet_amount.hide()
	await deal_next()


func _on_bet_amount_value_changed(value: float) -> void:
	if raised_once:
		refresh_table_labels("Raise: $"+str(int(round(value)))+" (dealer matches). Confirm Raise.")


func _on_fold_button_pressed() -> void:
	if round_busy or deal_state not in ["preflop", "flop", "turn", "river"]:
		return
	await game_over("fold")


func _on_play_again_pressed() -> void:
	get_tree().reload_current_scene()


func _on_back_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/casino.tscn")


func show_result(title: String, details: String) -> void:
	game_ui.hide()
	start_ui.hide()
	bet_amount.hide()
	end_ui.show()
	result_label.text = title
	result_details_label.text = details
	refresh_table_labels("Hand finished. Choose Play Again or Back to Casino.")


func game_over(state: String) -> void:
	if round_busy and state == "fold":
		return
	round_busy = true
	game_ui.hide()
	bet_amount.hide()
	raised_once = false
	raise_button.text = "Raise"

	if state == "fold":
		await reveal_dealer_hand()
		deal_state = "finished"
		round_busy = false
		show_result("You folded", "You lost $"+str(player_paid)+" in game chips.")
		return

	if community_cards.size() != 5 or player_hand.size() != 2 or house_hand.size() != 2:
		round_busy = false
		game_ui.show()
		refresh_table_labels("Cannot score: the board is incomplete.")
		return

	await reveal_dealer_hand()
	var outcome = did_player_win()
	var player_category = hand_name(calculate_score(player_hand + community_cards))
	var dealer_category = hand_name(calculate_score(house_hand + community_cards))
	var title = ""
	var details = "Your hand: "+player_category+"\nDealer hand: "+dealer_category

	match outcome:
		"true":
			title = "You win!"
			GameState.set_player_money(GameState.get_player_money() + pot)
			details += "\nYou receive $"+str(pot)+" in game chips."
		"false":
			title = "Dealer wins"
			details += "\nYou lost $"+str(player_paid)+" in game chips."
		"split":
			title = "Split pot"
			GameState.set_player_money(GameState.get_player_money() + int(pot / 2))
			details += "\nYou receive $"+str(int(pot / 2))+" in game chips."

	deal_state = "finished"
	round_busy = false
	show_result(title, details)


func hand_name(category: int) -> String:
	match category:
		10: return "Royal Flush"
		9: return "Straight Flush"
		8: return "Four of a Kind"
		7: return "Full House"
		6: return "Flush"
		5: return "Straight"
		4: return "Three of a Kind"
		3: return "Two Pair"
		2: return "One Pair"
		_: return "High Card"


func did_player_win() -> String:
	var player_cards = player_hand + community_cards
	var dealer_cards = house_hand + community_cards
	var player_score = calculate_score(player_cards)
	var dealer_score = calculate_score(dealer_cards)

	if player_score > dealer_score:
		return "true"
	elif player_score < dealer_score:
		return "false"
#switch case
	match player_score:
		10: return "split"
		9: return compare_ranks(check_straight_flush(player_cards), check_straight_flush(dealer_cards))
		8: return compare_ranks(check_four_of_a_kind(player_cards), check_four_of_a_kind(dealer_cards))
		7: return compare_ranks(check_full_house(player_cards), check_full_house(dealer_cards))
		6: return compare_ranks(check_flush(player_cards), check_flush(dealer_cards))
		5: return compare_ranks(check_straight(player_cards), check_straight(dealer_cards))
		4: return compare_ranks(check_three_of_a_kind(player_cards), check_three_of_a_kind(dealer_cards))
		3: return compare_ranks(check_two_pair(player_cards), check_two_pair(dealer_cards))
		2: return compare_ranks(check_one_pair(player_cards), check_one_pair(dealer_cards))
		1: return compare_ranks(check_high_card(player_cards), check_high_card(dealer_cards))
	return "split"


func calculate_score(available_cards) -> int:
	if not check_royal_flush(available_cards).is_empty():
		return 10
	elif not check_straight_flush(available_cards).is_empty():
		return 9
	elif not check_four_of_a_kind(available_cards).is_empty():
		return 8
	elif not check_full_house(available_cards).is_empty():
		return 7
	elif not check_flush(available_cards).is_empty():
		return 6
	elif not check_straight(available_cards).is_empty():
		return 5
	elif not check_three_of_a_kind(available_cards).is_empty():
		return 4
	elif not check_two_pair(available_cards).is_empty():
		return 3
	elif not check_one_pair(available_cards).is_empty():
		return 2
	else:
		return 1


func check_royal_flush(available_cards) -> Array:
	var required_ranks = [10, 11, 12, 13, 14]

	for suit in ["Hearts", "Diamonds", "Clubs", "Spades"]:
		var found_ranks = []

		for card in available_cards:
			if card.get_suit() == suit:
				found_ranks.append(card.get_rank_value())

		var royal_flush = true

		for rank in required_ranks:
			if rank not in found_ranks:
				royal_flush = false
				break

		if royal_flush:
			return [14]

	return []


func check_straight_flush(available_cards) -> Array:
	var highest_straight = 0

	for suit in ["Hearts", "Diamonds", "Clubs", "Spades"]:
		var found_ranks = []

		for card in available_cards:
			if card.get_suit() == suit:
				found_ranks.append(card.get_rank_value())

		if 14 in found_ranks:
			found_ranks.append(1)

		for high_rank in range(14, 4, -1):
			var straight_flush = true

			for rank in range(high_rank - 4, high_rank + 1):
				if rank not in found_ranks:
					straight_flush = false
					break

			if straight_flush:
				highest_straight = max(highest_straight, high_rank)
				break

	if highest_straight > 0:
		return [highest_straight]

	return []


func check_four_of_a_kind(available_cards) -> Array:
	var ranks = []

	for card in available_cards:
		ranks.append(card.get_rank_value())

	for rank in range(14, 1, -1):
		if ranks.count(rank) == 4:
			var kicker = 0

			for other_rank in ranks:
				if other_rank != rank:
					kicker = max(kicker, other_rank)

			return [rank, kicker]

	return []


func check_full_house(available_cards) -> Array:
	var ranks = []

	for card in available_cards:
		ranks.append(card.get_rank_value())

	for three_rank in range(14, 1, -1):
		if ranks.count(three_rank) >= 3:
			for pair_rank in range(14, 1, -1):
				if pair_rank != three_rank and ranks.count(pair_rank) >= 2:
					return [three_rank, pair_rank]

	return []


func check_flush(available_cards) -> Array:
	var best_flush = []

	for suit in ["Hearts", "Diamonds", "Clubs", "Spades"]:
		var suited_ranks = []

		for card in available_cards:
			if card.get_suit() == suit:
				suited_ranks.append(card.get_rank_value())

		if suited_ranks.size() >= 5:
			suited_ranks.sort()
			suited_ranks.reverse()
			var flush_ranks = suited_ranks.slice(0, 5)

			if best_flush.is_empty() or compare_rank_arrays(flush_ranks, best_flush) > 0:
				best_flush = flush_ranks

	return best_flush


func check_straight(available_cards) -> Array:
	var ranks = []

	for card in available_cards:
		var rank = card.get_rank_value()

		if rank not in ranks:
			ranks.append(rank)

	if 14 in ranks:
		ranks.append(1)

	for high_rank in range(14, 4, -1):
		var is_straight = true

		for rank in range(high_rank - 4, high_rank + 1):
			if rank not in ranks:
				is_straight = false
				break

		if is_straight:
			return [high_rank]

	return []


func check_three_of_a_kind(available_cards) -> Array:
	var ranks = []

	for card in available_cards:
		ranks.append(card.get_rank_value())

	ranks.sort()
	ranks.reverse()

	for rank in range(14, 1, -1):
		if ranks.count(rank) >= 3:
			var result = [rank]

			for kicker in ranks:
				if kicker != rank and result.size() < 3:
					result.append(kicker)

			return result

	return []


func check_two_pair(available_cards) -> Array:
	var ranks = []

	for card in available_cards:
		ranks.append(card.get_rank_value())

	var pairs = []

	for rank in range(14, 1, -1):
		if ranks.count(rank) >= 2:
			pairs.append(rank)

	if pairs.size() >= 2:
		var high_pair = pairs[0]
		var low_pair = pairs[1]
		var kicker = 0

		for rank in ranks:
			if rank != high_pair and rank != low_pair:
				kicker = max(kicker, rank)

		return [high_pair, low_pair, kicker]

	return []


func check_one_pair(available_cards) -> Array:
	var ranks = []

	for card in available_cards:
		ranks.append(card.get_rank_value())

	ranks.sort()
	ranks.reverse()

	for rank in range(14, 1, -1):
		if ranks.count(rank) >= 2:
			var result = [rank]

			for kicker in ranks:
				if kicker != rank and result.size() < 4:
					result.append(kicker)

			return result

	return []


func check_high_card(available_cards) -> Array:
	var ranks = []

	for card in available_cards:
		ranks.append(card.get_rank_value())

	ranks.sort()
	ranks.reverse()

	return ranks.slice(0, 5)


func compare_rank_arrays(a: Array, b: Array) -> int:
	for i in range(min(a.size(), b.size())):
		if a[i] > b[i]:
			return 1
		elif a[i] < b[i]:
			return -1

	return 0


func compare_ranks(player_ranks: Array, dealer_ranks: Array) -> String:
	for i in range(min(player_ranks.size(), dealer_ranks.size())):
		if player_ranks[i] > dealer_ranks[i]:
			return "true"
		elif player_ranks[i] < dealer_ranks[i]:
			return "false"

	return "split"


func _on_replay_button_pressed() -> void:
	_on_play_again_pressed()


func _on_exit_button_pressed() -> void:
	_on_back_button_pressed()
