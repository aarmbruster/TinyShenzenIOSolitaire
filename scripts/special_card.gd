tool
extends "res://scripts/card.gd"


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func set_resolved(in_resolved:bool):
	.set_resolved(in_resolved)
	if card_info.card_type < 6:
		$card_back.visible = true
