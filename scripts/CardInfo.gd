extends Object

class_name CardInfo

enum CardType { Coin = 0, Bamboo = 1, Char = 2, Green = 3, Red = 4, White = 5, Flower = 6, Holder = 7 }
enum CardState {None, Stacked, Temped, Resolved, PickedUp }

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
	var card_names = ["coins", "bamboo", "char", "dragon_green", "dragon_red", "dragon_white", "flower", "Holder"]
	print(card_names[index])
	return card_names[index]
