extends Node2D

enum HolderType { Stack = 0, Flower = 1, Resolved = 2, Temp = 3 }
export (HolderType) var holder_type = HolderType.Temp 
