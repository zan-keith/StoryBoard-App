extends Node2D



func _ready():
	pass # Replace with function body.


func _on_AddItem_pressed():
	var Item = load("res://Scenes/CustomCardItem.tscn").instance()
	get_node('./PanelContainer/VBoxContainer2').add_child(Item)
