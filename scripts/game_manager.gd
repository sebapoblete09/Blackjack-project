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
@onready var restart_button = $UI/RestartButton

@onready var deck_visual = $DeckVisual
@onready var animated_cards = $AnimateCards

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
	player_score_label.text = ""
	dealer_score_label.text = ""
	clear_table()

	
	#bloquear botones al comenzar el juego
	set_game_buttons(false)

	deck.create_deck()
	deck.shuffle_deck()

	await deal_initial_cards()

	# Habilitar botones luego de la repartida inicial
	set_game_buttons(true)




func dealer_turn():

	# Revelar la carta oculta
	await get_tree().create_timer(1.3).timeout
	reveal_dealer_card()

	await get_tree().create_timer(1.3).timeout

	# La banca debe pedir mientras tenga menos de 17
	while calculate_hand_value(dealer_hand) < 17:
		await get_tree().create_timer(1).timeout
		await deal_to_dealer()

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
	restart_button.disabled = false

# =========================
# PLAYER ACTIONS
# =========================

func _on_hit_button_pressed():

	if game_over or hit_button.disabled:
		return
	
	set_game_buttons(false)
		
	await deal_to_player()

	if is_bust(player_hand):
		determine_winner()
	else:
		set_game_buttons(true)


func _on_stand_button_pressed():

	if game_over or stand_button.disabled:
		return
	
	set_game_buttons(false)

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


func update_scores():
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


func reveal_dealer_card():
	# Verificar que la banca tenga al menos dos cartas
	if dealer_hand.size() < 2:
		return

	# Obtener la segunda carta visual de la banca
	var hidden_card = dealer_cards_container.get_child(1)

	# Mostrar su cara utilizando los datos reales
	hidden_card.set_card(dealer_hand[1])

	# Actualizar el estado y la puntuación
	reveal_dealer_cards = true
	update_scores()


func animate_card(
	container: HBoxContainer,
	card_data: Dictionary,
	face_down := false
):
	# 1. Crear la carta definitiva
	var final_card = CardScene.instantiate()
	container.add_child(final_card)

	if face_down:
		final_card.show_back()
	else:
		final_card.set_card(card_data)

	# 2. Ocultarla sin quitar su espacio del HBoxContainer
	final_card.modulate.a = 0.0

	# 3. Esperar a que Godot actualice el layout
	await get_tree().process_frame

	# 4. Obtener la posición definitiva
	var target_position = final_card.global_position

	# 5. Crear la carta que se animará
	var card = CardScene.instantiate()
	animated_cards.add_child(card)

	if face_down:
		card.show_back()
	else:
		card.set_card(card_data)

	# 6. Colocarla en el mazo
	card.global_position = deck_visual.global_position

	# 7. Animarla hacia su posición real
	var tween = create_tween()

	tween.tween_property(
		card,
		"global_position",
		target_position,
		0.5
	)

	await tween.finished

	# 8. Mostrar la carta definitiva y eliminar la temporal
	final_card.modulate.a = 1.0
	card.queue_free()


func set_game_buttons(enabled: bool):

	hit_button.disabled = not enabled
	stand_button.disabled = not enabled
	restart_button.disabled = not enabled

#Agregar un pequeño delay entre cada carta incial entregada	
func deal_initial_cards() -> void:

	await get_tree().create_timer(0.5).timeout
	
	await deal_to_player()
	await get_tree().create_timer(0.3).timeout

	await deal_to_dealer()	
	await get_tree().create_timer(0.3).timeout	
	
	await deal_to_player()
	await get_tree().create_timer(0.3).timeout

	await deal_to_dealer(true)
	await get_tree().create_timer(0.5).timeout	

func deal_to_player():
	var card = deck.draw_card()
	player_hand.append(card)
	await animate_card(
		player_cards_container,
		card
	)
	update_scores()
	
func deal_to_dealer(face_down:=false):
	var card = deck.draw_card()
	dealer_hand.append(card)
	await animate_card(
		dealer_cards_container,
		card,
		face_down
		)
	update_scores()
	
func clear_table():

	for child in player_cards_container.get_children():
		child.queue_free()

	for child in dealer_cards_container.get_children():
		child.queue_free()

	for child in animated_cards.get_children():
		child.queue_free()
	
