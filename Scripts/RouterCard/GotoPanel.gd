extends PanelContainer



func _on_AddVars_pressed():
	var var_details = load("res://Scenes/StoryCard/VarDetails.tscn").instance()
	$VBoxContainer/.add_child(var_details)
