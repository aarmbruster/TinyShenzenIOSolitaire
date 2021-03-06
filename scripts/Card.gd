tool
extends Node2D

class_name Card

const CardHolder = preload("CardHolder.gd")
const CardInfo = preload("CardInfo.gd")
const Statics = preload("Statics.gd")
export (CardInfo.CardType) var card_type setget set_card_type

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

var from_loc = Vector2.ZERO
var desired_parent = null
var last_child:Card = null

signal card_placed(placed_card)
signal card_dealt(dealt_card)
signal card_tweened(tweened_card)
signal card_transient(transient_card)

func _ready():
	if(card_info != null):
		card_type = card_info.card_type
		card_number = card_info.card_number
	icon = $main_icon
	if(icon != null):
		init_texture()

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
		return get_node("stackable").get_child(0) as Card
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

func deal(target_stackable:Node2D):
	if has_child():
		last_child = get_card_child() as Card
		$stackable.remove_child(last_child)
	place(target_stackable, 0.0, Statics.CARD_SPEED)
	emit_signal("card_dealt", self)
	
func place(target_stackable:Node2D, delay:float = 0.0, time:float = 0.0, offset:Vector2 = Vector2(0, 0)):
	if(get_parent() == null):
		return
		
	from_loc = self.global_position + offset
	get_parent().remove_child(self)
	emit_signal("card_transient", self)
	self.global_position = from_loc + offset
	desired_parent = target_stackable
	var tw = $tweener as Tween
	tw.interpolate_method(self, "tween_method", 0.0, 1.0, time, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, delay)
	$tweener.start()
	if time == 0.0:
		_on_tweener_tween_completed(self, "tween_method")

func tween_method(val):
	self.global_position = lerp(from_loc, desired_parent.global_position, val)
	self.z_index = 255
	if !dealt:
		$card_back.visible = false	

func _on_tweener_tween_completed(_object, _key):
	if(desired_parent):
		get_parent().remove_child(self)
		desired_parent.add_child(self)
		desired_parent = null
	if dealt:
		emit_signal("card_placed", self)
	else:
		$stackable.position = Vector2(0, 30)
		emit_signal("card_tweened", self)
		dealt = true
	self.position = Vector2.ZERO
	self.z_index = 0

func _on_TextureButton_button_down():
	if(can_pick_up()):
		mouse_offset = get_global_mouse_position() - self.global_position
		is_holding = true
		self.z_index = 255

func is_on_temp():
	if get_parent() == null || get_parent().get_parent() == null:
		return false
	var p = get_parent().get_parent() as CardHolder
	return p!=null && p.holder_type == CardHolder.HolderType.Temp

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
			place(drop_target.get_node("stackable"))
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
	$shadow.visible = !resolved
	$stackable.set_position(Vector2(0, get_stackable_offset()))

func reset():
	$shadow.visible = false
	$card_back.visible = true
	z_index = 0
	resolved = false
	$stackable.set_position(Vector2(0, 0))
	temped = false
	dealt = false
	is_holding = false
	desired_parent = null
	from_loc = Vector2.ZERO
