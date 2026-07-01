extends Node

var deck = []

func create_deck():
	deck.clear()
	var suits = ["♥", "♦", "♣", "♠"]
	var ranks = [
		{"rank": "A", "value": 11},
		{"rank": "2", "value": 2},
		{"rank": "3", "value": 3},
		{"rank": "4", "value": 4},
		{"rank": "5", "value": 5},
		{"rank": "6", "value": 6},
		{"rank": "7", "value": 7},
		{"rank": "8", "value": 8},
		{"rank": "9", "value": 9},
		{"rank": "10", "value": 10},
		{"rank": "J", "value": 10},
		{"rank": "Q", "value": 10},
		{"rank": "K", "value": 10}
		]
		
	for suit in suits:
		for rank_data in ranks:
			var card = {
				"suit": suit,
				"rank": rank_data["rank"],
				"value": rank_data["value"]
				}
			deck.append(card)
	
#Funcion para mezclar el deck
func shuffle_deck():
	deck.shuffle() #Se utiliza metodo shuffle, para evitar hacer algoritmo de mezcla propio

#Funcion para traer la carta de mas arriba del deck, Repartir carta
func draw_card():
	return deck.pop_back()
