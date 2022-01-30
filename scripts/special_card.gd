tool
extends "res://scripts/card.gd"

func set_resolved(in_resolved:bool):
	.set_resolved(in_resolved)
	if card_info.card_type < 6:
		$card_back.visible = true
