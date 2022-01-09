tool
extends Node2D

class_name card

const CardInfo = preload("CardInfo.gd") 
export (CardInfo.CardType) var card_type setget set_card_type

export var card_number:int = 1 setget set_card_number
onready var icon:Sprite = get_node("main_icon")

var drop_targets = []
var drop_target:Node2D = null

var is_holding = false
var mouse_offset = Vector2(0, 0)
var mouse_position = Vector2(0, 0)

var card_info:CardInfo = null
	
func _ready():
	if(card_info != null):
		card_type = card_info.card_type
		card_number = card_info.card_number
	icon = $main_icon
	if(icon != null):
		init_texture()
	pass

func init_texture():
	var texture_path:String;
	if(card_type > 2):
		texture_path = "res://source_content/textures/large_icons/" + CardInfo.card_names(card_type) + ".png"
	else:
		texture_path = "res://source_content/textures/large_icons/" + CardInfo.card_names(card_type) + "_" + String(card_number) + ".png"
	print("init_texture: " + texture_path)
	if(icon != null):
		icon.set_texture(load(texture_path))
		icon.modulate = CardInfo.get_modulate(card_type)

func set_card_type(value):
	card_type = value
	init_texture()
	pass

func set_card_number(value):
	card_number = int(clamp(value, 1, 9))
	print(card_number)
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
	self.z_index = 255
	pass # Replace with function body.

func _on_TextureButton_button_up():
	is_holding = false
	var can_accept = false
	if(drop_targets.size() > 0):
		var min_dist = -1.0
		for n in drop_targets:
			var dist = n.global_position.distance_to(self.global_position)
			if(dist < min_dist || min_dist == -1.0):
				min_dist = dist
				drop_target = n

	if(drop_target != null):
		can_accept = drop_target.get_node("stackable").can_accept_child(self)
		if(can_accept):
			get_parent().remove_child(self)
			drop_target.get_node("stackable").add_child(self)
	self.position = Vector2(0, 0)
	drop_target = null
	drop_targets.empty()
	self.z_index = 0

func _on_Area2D_area_entered(area):
	var p = area.get_parent() as Node2D
	if(p != null && is_holding):
		if(drop_targets.count(p) == 0):
			drop_targets.append(p)

func _on_Area2D_area_exited(area:Area2D):
	var p = area.get_parent() as Node2D
	if(p != null && is_holding):
		if(drop_targets.count(p) > 0):
			drop_targets.erase(p)
