extends Control

# =========================
# NODES
# =========================

@onready var deck = $Deck

@onready var player_cards_label = $PlayerArea/PlayerCardsLabel
@onready var dealer_cards_label = $DealerArea/DealerCardsLabel

@onready var player_score_label = $PlayerArea/PlayerScoreLabel
@onready var dealer_score_label = $DealerArea/DealerScoreLabel

@onready var result_label = $CenterArea/ResultLabel

@onready var hit_button = $UI/HitButton
@onready var stand_button = $UI/StandButton

# =========================
# GAME STATE
# =========================

var player_hand = []
var dealer_hand = []

var reveal_dealer_cards = false
var game_over = false

# =========================
# GODOT
# =========================

func _ready():
	start_game()

# =========================
# GAME FLOW
# =========================

func start_game():

	game_over = false
	reveal_dealer_cards = false

	player_hand.clear()
	dealer_hand.clear()

	result_label.text = ""

	set_game_buttons(true)

	deck.create_deck()
	deck.shuffle_deck()

	player_hand.append(deck.draw_card())
	player_hand.append(deck.draw_card())

	dealer_hand.append(deck.draw_card())
	dealer_hand.append(deck.draw_card())

	update_ui()


func dealer_turn():

	reveal_dealer_cards = true
	update_ui()

	while calculate_hand_value(dealer_hand) < 17:
		dealer_hand.append(deck.draw_card())
		update_ui()

	determine_winner()


func determine_winner():

	var player_total = calculate_hand_value(player_hand)
	var dealer_total = calculate_hand_value(dealer_hand)

	if player_total > 21:
		result_label.text = "Dealer Wins"

	elif dealer_total > 21:
		result_label.text = "Player Wins"

	elif player_total > dealer_total:
		result_label.text = "Player Wins"

	elif dealer_total > player_total:
		result_label.text = "Dealer Wins"

	else:
		result_label.text = "Draw"

	game_over = true
	set_game_buttons(false)

# =========================
# PLAYER ACTIONS
# =========================

func _on_hit_button_pressed():

	if game_over:
		return

	player_hand.append(deck.draw_card())

	update_ui()

	if is_bust(player_hand):
		determine_winner()


func _on_stand_button_pressed():

	if game_over:
		return

	dealer_turn()


func _on_restart_button_pressed():

	start_game()

# =========================
# GAME LOGIC
# =========================

func calculate_hand_value(hand):

	var total = 0
	var aces = 0

	for card in hand:

		total += card["value"]

		if card["rank"] == "A":
			aces += 1

	while total > 21 and aces > 0:
		total -= 10
		aces -= 1

	return total


func is_bust(hand):

	return calculate_hand_value(hand) > 21

# =========================
# UI
# =========================

func update_ui():

	player_cards_label.text = hand_to_string(player_hand)

	dealer_cards_label.text = hand_to_string(
		dealer_hand,
		not reveal_dealer_cards
	)

	player_score_label.text = "Score: " + str(calculate_hand_value(player_hand))

	if reveal_dealer_cards:
		dealer_score_label.text = "Score: " + str(calculate_hand_value(dealer_hand))
	else:
		dealer_score_label.text = "Score: " + str(dealer_hand[0]["value"])


func hand_to_string(hand, hide_second_card := false):

	var result = ""

	for i in range(hand.size()):

		if hide_second_card and i == 1:
			result += "[Hidden]   "
		else:
			var card = hand[i]
			result += card["rank"] + card["suit"] + "   "

	return result


func set_game_buttons(enabled: bool):

	hit_button.disabled = not enabled
	stand_button.disabled = not enabled
