tool
extends Node2D

class_name card

const CardInfo = preload("CardInfo.gd")
export (CardInfo.CardType) var card_type setget set_card_type

const card_holder = preload("card_holder.gd")

export var card_number:int = 1 setget set_card_number
onready var icon:Sprite = get_node("main_icon")
onready var top_icon:Sprite = get_node("top_icon")
onready var btm_icon:Sprite = get_node("btm_icon")

var drop_targets = []
var drop_target:Node2D = null

var resolved = false setget set_resolved
var is_holding = false
var mouse_offset = Vector2(0, 0)
var mouse_position = Vector2(0, 0)

var card_info:CardInfo = null

var temped = false
var dealt = false

var interp_val = 0.0

var from_loc = Vector2.ZERO
var desired_position = Vector2.ZERO

signal card_placed(placed_card)

func _ready():
	if(card_info != null):
		card_type = card_info.card_type
		card_number = card_info.card_number
	icon = $main_icon
	if(icon != null):
		init_texture()
	pass

func init_texture():
	var main_icon_path:String;
	if(card_type > 2):
		main_icon_path = "res://source_content/textures/large_icons/" + CardInfo.card_names(card_type) + ".png"
	else:
		main_icon_path = "res://source_content/textures/large_icons/" + CardInfo.card_names(card_type) + "_" + String(card_number) + ".png"
	if(icon != null):
		icon.set_texture(load(main_icon_path))
		if(card_type == CardInfo.CardType.Bamboo || card_type == CardInfo.CardType.Green):
			icon.self_modulate = CardInfo.get_modulate(card_type)
	
	var small_icon_path:String;
	small_icon_path = "res://source_content/textures/small_icons/" + CardInfo.card_names(card_type) + "_sm.png"
	if(top_icon != null):
		top_icon.set_texture(load(small_icon_path))
		if(card_type == CardInfo.CardType.Bamboo || card_type == CardInfo.CardType.Green):
			top_icon.self_modulate = CardInfo.get_modulate(card_type)
			top_icon.self_modulate = CardInfo.get_modulate(card_type)
	if(btm_icon != null):
		btm_icon.set_texture(load(small_icon_path))
		if(card_type == CardInfo.CardType.Bamboo || card_type == CardInfo.CardType.Green):
			btm_icon.self_modulate = CardInfo.get_modulate(card_type)
			btm_icon.self_modulate = CardInfo.get_modulate(card_type)

func has_child():
	return get_node("stackable").get_children().size() > 0

func get_card_child():
	if has_child():
		return get_node("stackable").get_child(0) as card
	return null

func can_pick_up():
	return !resolved && !has_child()

func set_card_type(value):
	card_type = value
	init_texture()

func set_card_number(value):
	card_number = int(clamp(value, 1, 9))
	init_texture()
	
func set_main(value):
	var i = get_node("main_icon")
	i.set_texture(value)

func _process(_delta):
	if(is_holding):
		self.global_position = get_global_mouse_position() - mouse_offset

func stackable_node():
	return get_node("stackable")

func place(target_stackable:Node2D, delay:float = 0.0, animate = true):
	if(get_parent() == null):
		return
	from_loc = self.global_position
	get_parent().remove_child(self)
	target_stackable.add_child(self)
	desired_position = target_stackable.global_position
	if animate:
		var tw = $tweener as Tween
		tw.interpolate_method(self, "tween_method", 0.0, 1.0, 0.2, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, 0)
		#$tweener.interpolate_property(self, "interp_val", 0.0, 1.0, 3, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, 0)
		$tweener.start()
	else:
		self.z_index = 0

func tween_method(val):
	if(self.card_type == CardInfo.CardType.Flower):
		print("val: " + str(val))
	self.global_position = lerp(from_loc, desired_position, val)

func _on_TextureButton_button_down():
	if(can_pick_up()):
		mouse_offset = get_global_mouse_position() - self.global_position
		is_holding = true
		self.z_index = 255

func is_on_temp():
	if get_parent() == null || get_parent().get_parent() == null:
		return false
	var p = get_parent().get_parent() as card_holder
	return p!=null && p.holder_type == card_holder.HolderType.Temp

func _on_TextureButton_button_up():
	#temporary debug testing option for removing cards from a stack
	if(Input.is_key_pressed(KEY_CONTROL)):
		if get_parent() != null:
			get_parent().remove_child(self)
	
	is_holding = false
	var can_accept = false
	if(drop_targets.size() > 0):
		var min_dist = -1.0
		for n in drop_targets:
			var dist = n.global_position.distance_to(self.global_position)
			if(dist < min_dist || min_dist == -1.0 && n.get_node("stackable").can_accept_child(self)):
				min_dist = dist

				drop_target = n
	if(drop_target != null):
		can_accept = drop_target.get_node("stackable").can_accept_child(self)
		if(can_accept):
			place(drop_target.get_node("stackable"), false)
	self.position = Vector2(0, 0)
	drop_targets.empty()
	self.z_index = 0
	if drop_target != null:
		drop_target = null

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

func get_stackable_offset():
	var r = 0 if resolved else 30
	return r

func set_resolved(in_resolved:bool):
	resolved = in_resolved
	$stackable.set_position(Vector2(0, get_stackable_offset()))

func _on_tweener_tween_completed(_object, _key):
	if dealt:
		emit_signal("card_placed", self)
		self.position = Vector2.ZERO
		self.z_index = 0
	else:
		print("dealt")
		dealt = true

func _on_tweener_tween_step(object:Object, key:NodePath, elapsed:float, value:Object):
	var c = object as card
	#print("elapsed: " + str(c.interp_val))
	

	#self.global_position = lerp(global_position, desired_position, c.interp_val)
