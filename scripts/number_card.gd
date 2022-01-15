extends card

class_name number_card

onready var number_top:Sprite = get_node("number_top")
onready var number_bottom:Sprite = get_node("number_bottom")

func _ready():
	._ready()
	init_texture()


func init_texture():
	.init_texture()
	if(number_top!=null):
		print(number_top.name)
		number_top.modulate = CardInfo.get_modulate(card_type)
		number_bottom.modulate = CardInfo.get_modulate(card_type)
