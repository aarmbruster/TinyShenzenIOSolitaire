extends Node2D

const card = preload("card.gd")
const card_holder = preload("card_holder.gd")

func can_accept_child(child:card):
	var card_child = get_child(0) as card
	if(card_child != null):
		return false #there is already a child on this card

	var card_parent = get_parent() as card

	if(card_parent != null):
		if(card_parent.card_type != child.card_type && card_parent.card_number - child.card_number == 1):
			return true
	var holder_parent = get_parent() as card_holder
	if(holder_parent != null):
		return true
	return false
	#var card_child  = get_parent().get_child(get_parent().get_child_count() - 1) as card
#
	#if(card_child != null):
	#	return false #there is already a child on this card
#
	#var card_parent = get_parent() as card
#
	#if(card_parent != null):
	#	if(card_child == null && card_parent.card_type != child.card_type && card_parent.card_number - child.card_number == 1):
	#		return true
	#	else:
	#		return false
	#return true


func _on_Area2D_mouse_entered():
	print("mouse entered stackable")
	pass # Replace with function body.


func _on_Area2D_mouse_exited():
	print("mouse exited stackable")
	pass # Replace with function body.


func _on_Area2D_input_event(viewport, event, shape_idx):
	var mouse_event = event as InputEventMouseButton;
	if(mouse_event != null):
		print(mouse_event.pressed)
	#if(mouse_event == InputEventMouseButton.pressed):
		#print("mouse pressed on this")
	pass # Replace with function body.
