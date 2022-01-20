extends Object

class_name CardInfo

const CardColors = preload("CardColors.gd")
enum CardType { Coin = 0, Bamboo = 1, Char = 2, Red = 3, Green = 4, White = 5, Flower = 6}
enum CardState { None, Stacked, Temped, Resolved, PickedUp }

var card_type = CardType.Flower
var card_number:int = -1

func _init(in_type, in_number:int):
	card_type = in_type
	card_number = in_number
	
static func card_names(index):
	var card_names = ["coins", "bamboo", "char", "dragon_red", "dragon_green", "dragon_white", "flower"]
	return card_names[index]

static func get_modulate(in_card_type:int):
	var modulated_color = [CardColors.red(), CardColors.green(), CardColors.black(), CardColors.red(), CardColors.green(), CardColors.black(), CardColors.white()]
	return modulated_color[in_card_type]
