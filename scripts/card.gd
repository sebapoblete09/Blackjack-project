extends Control




@onready var texture_rect= $TextureRect

const CARD_WIDTH = 32
const CARD_HEIGHT = 48
const CARD_SCALE =  2.0

const CARD_TEXTURE = preload("res://assets/cards/spritesheet.png")


func set_region(x: int, y: int):

	var atlas = AtlasTexture.new()

	atlas.atlas = CARD_TEXTURE

	atlas.region = Rect2(
		x * CARD_WIDTH,
		y * CARD_HEIGHT,
		CARD_WIDTH,
		CARD_HEIGHT
	)

	texture_rect.texture = atlas
	texture_rect.scale = Vector2(2, 2)
	


func set_card(card_data):

	var rank_order = [
		"A","2","3","4","5","6","7","8","9","10","J","Q","K"
	]

	var suit_order = [
		"♠",
		"♣",
		"♥",
		"♦"
	]

	var x = rank_order.find(card_data["rank"])
	var y = suit_order.find(card_data["suit"])

	set_region(x, y)
	
func show_back():

	var atlas = AtlasTexture.new()
	atlas.atlas = CARD_TEXTURE

	atlas.region = Rect2(
		0,
		4 * CARD_HEIGHT + 6,
		CARD_WIDTH,
		CARD_HEIGHT
	)

	texture_rect.texture = atlas
	texture_rect.scale = Vector2(2, 2)

func _ready():
	custom_minimum_size = Vector2(
		CARD_WIDTH * CARD_SCALE,
		CARD_HEIGHT* CARD_SCALE
	)
