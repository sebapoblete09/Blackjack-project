extends Control
const CardScene = preload("res://scenes/card.tscn")
# =========================
# NODES
# =========================

@onready var deck = $Deck

@onready var player_cards_container = $PlayerArea/PlayerCardsContainer
@onready var dealer_cards_container = $DealerArea/DealerCardsContainer

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

func start_game()->void:

	game_over = false
	reveal_dealer_cards = false

	player_hand.clear()
	dealer_hand.clear()

	result_label.text = ""

	set_game_buttons(true)

	deck.create_deck()
	deck.shuffle_deck()

	await deal_initial_cards()



func dealer_turn():

	reveal_dealer_cards = true
	update_ui()
	await get_tree().create_timer(1.3).timeout
	while calculate_hand_value(dealer_hand) < 17:
		dealer_hand.append(deck.draw_card())
		update_ui()
		await get_tree().create_timer(1).timeout

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

func clear_cards(container):
	for child in container.get_children():
		child.queue_free()

func draw_hand(hand, container, hide_second := false):

	clear_cards(container)
	
	for i in range(hand.size()):
		
		var card = CardScene.instantiate()
		container.add_child(card)
		if hide_second and i ==1:
			card.show_back()
		else:
			card.set_card(hand[i])
		
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

	draw_hand(player_hand, player_cards_container)
	draw_hand(dealer_hand, dealer_cards_container,not reveal_dealer_cards)
	
	if player_hand.is_empty():
		player_score_label.text = "Score: 0"
	else:
		player_score_label.text = "Score: " + str(calculate_hand_value(player_hand))

	if dealer_hand.is_empty():
		dealer_score_label.text = "Score: 0"

	elif reveal_dealer_cards:
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

#Agregar un pequeño delay entre cada carta incial entregada	
func deal_initial_cards() -> void:

	await get_tree().create_timer(0.5).timeout
	
	player_hand.append(deck.draw_card())
	update_ui()
	await get_tree().create_timer(0.3).timeout

	dealer_hand.append(deck.draw_card())
	update_ui()
	await get_tree().create_timer(0.3).timeout	
	
	player_hand.append(deck.draw_card())
	update_ui()
	await get_tree().create_timer(0.3).timeout

	dealer_hand.append(deck.draw_card())
	update_ui()
	await get_tree().create_timer(0.5).timeout	
