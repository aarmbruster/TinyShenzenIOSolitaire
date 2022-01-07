tool
extends Node2D

class_name card

export var card_number = 0

enum CardType { Coin, Bamboo, Char, Green, Red, White, Flower, Holder }
enum CardState{None, Stacked, Temped, Resolved, PickedUp }

export var card_type = CardType.Flower

export var main_texture = preload("res://icon.png") setget set_main
export var  card_name = "tmp"
onready var icon = get_node("main_icon")

var current_drop_target:card = null;

var is_holding = false
var mouse_offset = Vector2(0, 0)
var mouse_position = Vector2(0, 0)

#onready var main_icon = get_node("main_icon")
# Called when the node enters the scene tree for the first time.
func _ready():
	icon.set_texture(main_texture)
	pass
	#main_icon.set_texture(card_icon)
	#btn_sprite.texture = card_icon;

func set_main(value):
	var i = get_node("main_icon")
	main_texture = value
	i.set_texture(value)
	pass

func _process(delta):
	if(is_holding):
		self.global_position = get_global_mouse_position() - mouse_offset
	pass

func _on_TextureButton_pressed():
	pass # Replace with function body.

func _on_TextureButton_button_down():
	mouse_offset = get_global_mouse_position() - self.global_position 
	is_holding = true
	pass # Replace with function body.

func _on_TextureButton_button_up():
	is_holding = false
	var can_accept = false
	if(current_drop_target != null):
		can_accept = current_drop_target.can_accept_child(self)
	if(can_accept):
		self.get_parent().remove_child(self)
		current_drop_target.add_child(self)
		var count = 0;
		current_drop_target.get_children().count(count)
		print(current_drop_target.name + " | " + count as String)
pass

func _on_Area2D_area_entered(area):
	var p = area.get_parent() as card
	if(p != null && is_holding):
		current_drop_target = p
	pass # Replace with function body.

func can_accept_child(child):
	var card_child = child as card
	if(card_child != null):
		var count = 0;
		self.get_children().count(count)
		if(count > 0):
			return false
		if(self.card_type != card_child.card_type && self.card_number - child.card_number == 1):
			return true
	return false

func _on_Area2D_body_entered(body):
	print(body)
	pass # Replace with function body.


func _on_Area2D_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	pass # Replace with function body.
