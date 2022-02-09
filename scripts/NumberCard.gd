extends Card

class_name NumberCard

onready var number_top:Sprite = get_node("number_top")
onready var number_bottom:Sprite = get_node("number_bottom")

func _ready():
	._ready()
	init_texture()

func init_texture():
	.init_texture()
	if(number_top!=null):
		number_top.self_modulate = CardInfo.get_modulate(card_type)
		number_bottom.self_modulate = CardInfo.get_modulate(card_type)
		var number_path = "res://source_content/textures/number_" + String(card_number) + ".png"
		number_top.set_texture(load(number_path))
		number_bottom.set_texture(load(number_path))

func can_pick_up():
	var child = get_card_child()
	if(child != null):
		var num_child = child as NumberCard
		if(num_child != null && child.card_type != card_type && self.card_number - num_child.card_number == 1):
			return num_child.can_pick_up()
	return .can_pick_up()


func _on_tweener_tween_completed(_object, _key):
	._on_tweener_tween_completed(_object, _key)
