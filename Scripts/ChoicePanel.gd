extends PanelContainer
signal TextEntered

func _on_AddVar_pressed():
	var var_details = load("res://Scenes/StoryCard/VarDetails.tscn").instance()
	$VBoxContainer.add_child(var_details)


func _on_Goto_text_entered(new_text):
	emit_signal("TextEntered",new_text,self)
	

