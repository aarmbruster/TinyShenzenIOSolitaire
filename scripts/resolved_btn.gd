extends Node2D

class_name resolved_btn

var is_ready_to_resolve: bool = false
var is_resolved: bool = false

enum ButtonType {Red = 0, Green = 1, White = 2}
export (ButtonType) var btn_type setget set_btn_type

signal resolved(btn_type)

onready var btn = get_node("btn")

var btn_names = ["red", "green", "white"]
# Called when the node enters the scene tree for the first time.

func set_ready_state(in_is_ready:bool):
	is_ready_to_resolve = in_is_ready
	if is_ready_to_resolve && !is_resolved:
		$btn.texture_normal = load("res://source_content/textures/button_" + btn_names[btn_type] + "_active.png")
		$btn.texture_hover = load("res://source_content/textures/button_" + btn_names[btn_type] + "_active.png")
	else:
		$btn.texture_normal = load("res://source_content/textures/button_" + btn_names[btn_type] + "_up.png")

func set_resolved_state(in_is_resolved:bool):
	is_resolved = in_is_resolved
	$btn.disabled=is_resolved
	if is_resolved:
		$btn.texture_normal = load("res://source_content/textures/button_" + btn_names[btn_type] + "_down.png")
		$btn.texture_hover = load("res://source_content/textures/button_" + btn_names[btn_type] + "_down.png")
	else:
		$btn.texture_normal = load("res://source_content/textures/button_" + btn_names[btn_type] + "_up.png")

func _on_btn_pressed():
	if is_ready_to_resolve && !is_resolved:
		set_resolved_state(true)
		emit_signal("resolved", btn_type)

func init_cosmetics():
	$btn.texture_normal = load("res://source_content/textures/button_" + btn_names[btn_type] + "_up.png")
	$btn.texture_focused = load("res://source_content/textures/button_" + btn_names[btn_type] + "_up.png")
	$btn.texture_pressed = load("res://source_content/textures/button_" + btn_names[btn_type] + "_up.png")
	$btn.texture_disabled = load("res://source_content/textures/button_" + btn_names[btn_type] + "_down.png")
	$btn.texture_hover = load("res://source_content/textures/button_" + btn_names[btn_type] + "_up.png")

func _ready():
	init_cosmetics()

func set_btn_type(in_btn_type):
	btn_type = in_btn_type
	init_cosmetics()
