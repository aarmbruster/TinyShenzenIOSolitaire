tool
extends Node2D

class_name card

const CardInfo = preload("CardInfo.gd") 
export (CardInfo.CardType) var card_type setget set_card_type

export var card_number:int = 1 setget set_card_number
var card_name = "bamboo"
onready var icon = get_node("main_icon")

var current_drop_target:card = null;

var is_holding = false
var mouse_offset = Vector2(0, 0)
var mouse_position = Vector2(0, 0)

func _init(in_card_info:CardInfo = null):
	if(in_card_info != null):
		card_name = in_card_info.card_name
	
func _ready():
	icon = $main_icon
	if(icon != null):
		init_texture()
	pass

func init_texture():
	var texture_path = "res://source_content/textures/large_icons/" + CardInfo.card_names(card_type) + "_" + String(card_number) + ".png"
	print(texture_path)
	if(icon != null):
		icon.set_texture(load(texture_path))

func set_card_type(value):
	card_type = value
	init_texture()
	pass

func set_card_number(value):
	card_number = value
	init_texture()
	pass
	
func set_main(value):
	var i = get_node("main_icon")
	#main_texture = value
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
