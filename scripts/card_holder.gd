extends Node2D

enum HolderType { Stack = 0, Flower = 1, Resolved = 2, Temp = 3 }
export (HolderType) var holder_type = HolderType.Temp 

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_CollisionShape2D_tree_entered():
	pass # Replace with function body.
