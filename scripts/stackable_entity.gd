extends Node2D


export var card_name = ""

export var stackoffset = 1.0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Area2D_mouse_entered():
	print("mouse entered stackable")
	pass # Replace with function body.


func _on_Area2D_mouse_exited():
	print("mouse exited stackable")
	pass # Replace with function body.


func _on_Area2D_input_event(viewport, event, shape_idx):
	var mouse_event = event as InputEventMouseButton;
	if(mouse_event != null):
		print(mouse_event.pressed)
	#if(mouse_event == InputEventMouseButton.pressed):
		#print("mouse pressed on this")
	pass # Replace with function body.


func _on_TextureButton_button_down():
	print("Card " + card_name + " texture button pressed")
	pass # Replace with function body.
