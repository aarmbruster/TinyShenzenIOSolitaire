extends Node2D

const CardInfo = preload("CardInfo.gd")
export (CardInfo.CardType) var card_type setget set_card_type
export var disabled_texture = preload("res://source_content/textures/button_green_down.png");

signal resolved_activated(card_type)

onready var btn = get_node("btn")

# Called when the node enters the scene tree for the first time.
func _ready():
	btn.texture_disabled = disabled_texture;

	pass
	
func _on_btn_pressed():
	emit_signal("resolved_activated", card_type)
	#btn_sprite.texture = card_icon;

func set_card_type(in_card_type):
	card_type = in_card_type
	pass
