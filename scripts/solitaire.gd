extends Node

class_name solitaire

const CardInfo = preload("CardInfo.gd") 
const card = preload("card.gd")

onready var stacks = [
	$stack_holders/stack_card_holder_0,
	$stack_holders/stack_card_holder_1,
	$stack_holders/stack_card_holder_2,
	$stack_holders/stack_card_holder_3,
	$stack_holders/stack_card_holder_4,
	$stack_holders/stack_card_holder_5,
	$stack_holders/stack_card_holder_6,
	$stack_holders/stack_card_holder_7
]

var cards_infos = [
	CardInfo.new(CardInfo.CardType.Char, 1),
	CardInfo.new(CardInfo.CardType.Char, 2),
	CardInfo.new(CardInfo.CardType.Char, 3),
	CardInfo.new(CardInfo.CardType.Char, 4),
	CardInfo.new(CardInfo.CardType.Char, 5),
	CardInfo.new(CardInfo.CardType.Char, 6),
	CardInfo.new(CardInfo.CardType.Char, 7),
	CardInfo.new(CardInfo.CardType.Char, 8),
	CardInfo.new(CardInfo.CardType.Char, 9),
	CardInfo.new(CardInfo.CardType.Bamboo, 1),
	CardInfo.new(CardInfo.CardType.Bamboo, 2),
	CardInfo.new(CardInfo.CardType.Bamboo, 3),
	CardInfo.new(CardInfo.CardType.Bamboo, 4),
	CardInfo.new(CardInfo.CardType.Bamboo, 5),
	CardInfo.new(CardInfo.CardType.Bamboo, 6),
	CardInfo.new(CardInfo.CardType.Bamboo, 7),
	CardInfo.new(CardInfo.CardType.Bamboo, 8),
	CardInfo.new(CardInfo.CardType.Bamboo, 9),
	CardInfo.new(CardInfo.CardType.Coin, 1),
	CardInfo.new(CardInfo.CardType.Coin, 2),
	CardInfo.new(CardInfo.CardType.Coin, 3),
	CardInfo.new(CardInfo.CardType.Coin, 4),
	CardInfo.new(CardInfo.CardType.Coin, 5),
	CardInfo.new(CardInfo.CardType.Coin, 6),
	CardInfo.new(CardInfo.CardType.Coin, 7),
	CardInfo.new(CardInfo.CardType.Coin, 8),
	CardInfo.new(CardInfo.CardType.Coin, 9),
	CardInfo.new(CardInfo.CardType.Green, 0),
	CardInfo.new(CardInfo.CardType.Green, 0),
	CardInfo.new(CardInfo.CardType.Green, 0),
	CardInfo.new(CardInfo.CardType.Green, 0),
	CardInfo.new(CardInfo.CardType.Red, 0),
	CardInfo.new(CardInfo.CardType.Red, 0),
	CardInfo.new(CardInfo.CardType.Red, 0),
	CardInfo.new(CardInfo.CardType.Red, 0),
	CardInfo.new(CardInfo.CardType.White, 0),
	CardInfo.new(CardInfo.CardType.White, 0),
	CardInfo.new(CardInfo.CardType.White, 0),
	CardInfo.new(CardInfo.CardType.White, 0),
	CardInfo.new(CardInfo.CardType.Flower, 0)
]

var cards = []


func _ready():
	randomize()
	cards_infos.shuffle()
	var card_scene = load("res://entities/card.tscn")
	var card_number_scene = load("res://entities/number_card.tscn")
	var p = get_node("resolved_holders/flower_resolved_card_holder")
	for card_info in cards_infos:
		var card_inst
		if(card_info.card_type < 3):
			card_inst = card_number_scene.instance()
		else:
			card_inst = card_scene.instance()
		cards.append(card_inst)
		card_inst.card_info = card_info
		p.add_child(card_inst)
		p = card_inst
	
	var i_stack = 0
	while (p as card) != null:
		var parent = p.get_parent()
		parent.remove_child(p)
		stacks[i_stack % 8].get_node("stackable").add_child(p)
		stacks[i_stack % 8] = p
		p = parent
		i_stack+=1
		#var tween = c.get_node("Tween")
		#tween.interpolate_property(c, "position", c.position, Vector2(0, 0), 1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		#tween.start()
		
