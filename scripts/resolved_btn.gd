extends Node2D


export var disabled_texture = preload("res://source_content/textures/button_green_down.png");

onready var btn = get_node("btn")

# Called when the node enters the scene tree for the first time.
func _ready():
	btn.texture_disabled = disabled_texture;
	pass
	
func _on_btn_pressed():
	print("button pressed")
	#btn_sprite.texture = card_icon;
