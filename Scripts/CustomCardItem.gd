extends PanelContainer



func _ready():
	pass # Replace with function body.


func _on_Add_pressed():
	var hbox = HBoxContainer.new()
	
	get_node("./Characters").add_child(hbox)
	get_node("./Characters/"+hbox.name).add_child(hbox).add_child()
