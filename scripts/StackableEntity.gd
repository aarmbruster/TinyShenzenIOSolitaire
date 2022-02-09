extends Node2D

const card = preload("Card.gd")
const card_holder = preload("CardHolder.gd")

func can_accept_child(child:Card):
	if(get_children().size() > 0):
		return false #there is already a child on this card

	var card_parent = get_parent() as Card

	if(card_parent != null):
		if(card_parent.card_type != child.card_type && card_parent.card_number - child.card_number == 1):
			return true
		if card_parent.resolved && card_parent.card_type == child.card_type && child.card_number - card_parent.card_number == 1:
			child.set_resolved(true) # this need removed and refactored to exist in the solitaire class
			return true
	var holder_parent = get_parent() as card_holder
	if(holder_parent != null):
		if(holder_parent.holder_type == card_holder.HolderType.Temp && child.has_child()):
			return false
		if(holder_parent.holder_type == card_holder.HolderType.Flower || holder_parent.holder_type == card_holder.HolderType.Resolved):
			return false
		return true
	return false
