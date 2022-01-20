extends Node

class_name solitaire

const CardInfo = preload("CardInfo.gd") 
const card = preload("card.gd")
const number_card = preload("number_card.gd")
const card_holder = preload("card_holder.gd")

onready var stacks = [ $stack_holders/stack_card_holder_0, $stack_holders/stack_card_holder_1, $stack_holders/stack_card_holder_2, $stack_holders/stack_card_holder_3, $stack_holders/stack_card_holder_4, $stack_holders/stack_card_holder_5, $stack_holders/stack_card_holder_6, $stack_holders/stack_card_holder_7]
onready var resolved_stacks = [$resolved_holders/green_resolved_card_holder, $resolved_holders/white_resolved_card_holder, $resolved_holders/red_resolved_card_holder]
onready var tmp_stacks = [$tmp_holders/tmp_card_holder_0, $tmp_holders/tmp_card_holder_1, $tmp_holders/tmp_card_holder_2]
onready var resolved_btns = [$resolved_btns/red_resolve_btn, $resolved_btns/green_resolve_btn, $resolved_btns/white_resolve_btn]

var cards_infos = [
	CardInfo.new(CardInfo.CardType.Char, 1), CardInfo.new(CardInfo.CardType.Char, 2), CardInfo.new(CardInfo.CardType.Char, 3), CardInfo.new(CardInfo.CardType.Char, 4), CardInfo.new(CardInfo.CardType.Char, 5), CardInfo.new(CardInfo.CardType.Char, 6), CardInfo.new(CardInfo.CardType.Char, 7), CardInfo.new(CardInfo.CardType.Char, 8), CardInfo.new(CardInfo.CardType.Char, 9),
	CardInfo.new(CardInfo.CardType.Bamboo, 1), CardInfo.new(CardInfo.CardType.Bamboo, 2), CardInfo.new(CardInfo.CardType.Bamboo, 3), CardInfo.new(CardInfo.CardType.Bamboo, 4), CardInfo.new(CardInfo.CardType.Bamboo, 5), CardInfo.new(CardInfo.CardType.Bamboo, 6), CardInfo.new(CardInfo.CardType.Bamboo, 7), CardInfo.new(CardInfo.CardType.Bamboo, 8), CardInfo.new(CardInfo.CardType.Bamboo, 9),
	CardInfo.new(CardInfo.CardType.Coin, 1), CardInfo.new(CardInfo.CardType.Coin, 2), CardInfo.new(CardInfo.CardType.Coin, 3), CardInfo.new(CardInfo.CardType.Coin, 4), CardInfo.new(CardInfo.CardType.Coin, 5), CardInfo.new(CardInfo.CardType.Coin, 6), CardInfo.new(CardInfo.CardType.Coin, 7), CardInfo.new(CardInfo.CardType.Coin, 8), CardInfo.new(CardInfo.CardType.Coin, 9),
	CardInfo.new(CardInfo.CardType.Red, 0), CardInfo.new(CardInfo.CardType.Red, 0), CardInfo.new(CardInfo.CardType.Red, 0), CardInfo.new(CardInfo.CardType.Red, 0),
	CardInfo.new(CardInfo.CardType.Green, 0), CardInfo.new(CardInfo.CardType.Green, 0), CardInfo.new(CardInfo.CardType.Green, 0), CardInfo.new(CardInfo.CardType.Green, 0),
	CardInfo.new(CardInfo.CardType.White, 0), CardInfo.new(CardInfo.CardType.White, 0), CardInfo.new(CardInfo.CardType.White, 0),CardInfo.new(CardInfo.CardType.White, 0),
	CardInfo.new(CardInfo.CardType.Flower, 0)
]

var cards = []

var green_ready = false
var white_ready = false
var red_ready = false

func _ready():

	for resolve_btn in resolved_btns:
		resolve_btn.connect("resolved", self, "_on_resolved_pressed")

	#randomize()
	#cards_infos.shuffle()
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
		card_inst.connect("card_placed", self, "_on_card_placed")
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
	
	check_ends()
	if cards.size() > 0:
		_on_card_placed(cards[cards.size() - 1])

func check_ends():
	for e in stacks:
		var c = e as card
		if c.card_type == CardInfo.CardType.Flower:
			c.get_parent().remove_child(c)
			$resolved_holders/flower_resolved_card_holder.get_node("stackable").add_child(c)

func try_resolve_card(in_card):
	var resolved_h = resolved_stacks[in_card.card_type] as card_holder
	var number_c = in_card as number_card
	if resolved_h != null && number_c != null  && number_c.card_number == 1:
		number_c.place(resolved_h.get_node("stackable"))
		resolved_stacks[in_card.card_type] = number_c
		return true
	
	var resolved_c = resolved_stacks[in_card.card_type] as number_card
	if resolved_c != null && number_c != null && in_card.card_number - resolved_c.card_number == 1:
		number_c.place(resolved_c.get_node("stackable"))
		resolved_stacks[in_card.card_type] = number_c
		return true
	return false

func is_tmp_avail():
	for h in tmp_stacks:
		if h.get_node("stackable").get_child_count() < 1:
			return true
	return false

func check_special(spot_avail: bool, special_cards):
	if special_cards.size() < 4:
		return false

	for s in special_cards:
		if spot_avail || s.is_on_temp():
			return true
	return false

func _on_card_placed(placed_card:card):
	#iterate through cards to see if we can auto-resolve
	var check_again = false
	var white_cards = []
	var green_cards = []
	var red_cards = []
	for c in cards:
		if c.resolved:
			continue
		if c.get_card_child() != null:
			continue
		if c.card_type == CardInfo.CardType.Flower && !c.resolved:
			c.get_parent().remove_child(c)
			$resolved_holders/flower_resolved_card_holder.get_node("stackable").add_child(c)
			c.set_resolved(true)
			check_again = true
			break
		if c.card_type < 3 && !c.resolved: #if it's a number card try to resolve
			if try_resolve_card(c):
				c.set_resolved(true)
				check_again = true
				break
		
		if c.card_type == CardInfo.CardType.Red:
			red_cards.append(c)
		if c.card_type == CardInfo.CardType.Green:
			green_cards.append(c)
		if c.card_type == CardInfo.CardType.White:
			white_cards.append(c)

	var tmp_spot_avail = is_tmp_avail()
	red_ready =  check_special(tmp_spot_avail, red_cards)
	green_ready =  check_special(tmp_spot_avail, green_cards)
	white_ready =  check_special(tmp_spot_avail, white_cards)
	
	if(red_ready):
		$resolved_btns/red_resolve_btn.set_ready_state(true)
	if(green_ready):
		$resolved_btns/green_resolve_btn.set_ready_state(true)
	if(white_ready):
		$resolved_btns/white_resolve_btn.set_ready_state(true)

	if check_again:
		_on_card_placed(null)

func get_resolve_holder(specials):
	for s in specials:
		if s.is_on_temp():
			return s.get_parent().get_parent()
	for h in tmp_stacks:
		if h.get_node("stackable").get_child_count() < 1:
			return h
	return null

func resolve_special(in_card_type:int):
	var specials = []
	for c in cards:
		if c.card_type == in_card_type + 3:
			specials.append(c)
	var resolve_stack = get_resolve_holder(specials)
	for s in specials:
		s.place(resolve_stack.get_node("stackable"))
		s.set_resolved(true)

func _on_resolved_pressed(card_type:int):
	if(card_type == 0 && red_ready):
		resolve_special(card_type)
		return
	if(card_type == 1 && green_ready):
		resolve_special(card_type)
		return
	if(card_type == 2 && white_ready):
		resolve_special(card_type)
		return


