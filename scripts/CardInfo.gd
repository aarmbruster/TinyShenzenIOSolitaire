extends Object

class_name CardInfo

const CardColors = preload("CardColors.gd")
enum CardType { Coin = 0, Bamboo = 1, Char = 2, Green = 3, Red = 4, White = 5, Flower = 6}
enum CardState { None, Stacked, Temped, Resolved, PickedUp }

var card_name = ""
var texture:Texture = null
var card_Type = CardType.Flower
var card_number:int = -1

func _init(in_type, in_name:String, in_texture:String, in_number:int):
	card_Type = in_type
	card_name = in_name
	texture = load(in_texture)
	card_number = in_number
	pass
	
static func card_names(index):
	var card_names = ["coins", "bamboo", "char", "dragon_green", "dragon_red", "dragon_white", "flower"]
	print(card_names[index])
	return card_names[index]

static func get_modulate(card_type:int):
	var modulated_color = [CardColors.white(), CardColors.green(), CardColors.white(), CardColors.green(), CardColors.white(), CardColors.white(), CardColors.white()]
	return modulated_color[card_type]
