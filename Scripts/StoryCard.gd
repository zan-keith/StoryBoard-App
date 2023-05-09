extends PanelContainer

signal SendClick
signal RefreshLines

onready var toggle=false
onready var focused=false

func _on_AddVar_pressed():
	var var_details = load("res://Scenes/StoryCard/VarDetails.tscn").instance()
	get_node("./VBoxContainer/OnStart/VBox/Reqs").add_child(var_details)
	var_details.visible=true

func _on_OnEndAddVar_pressed():
	var var_details = load("res://Scenes/StoryCard/VarDetails.tscn").instance()
	get_node("./VBoxContainer/OnEnd/VBoxContainer/SetVars").add_child(var_details)
	var_details.visible=true
	

func _on_EditButton_pressed():
	$VBoxContainer/Content/TypeContent.visible=true
	$VBoxContainer/Content/TypeContent.text=$VBoxContainer/Content/ContentLabel.get_text()


func _on_SaveContentButton_pressed():
	$VBoxContainer/Content/TypeContent.visible=false
	$VBoxContainer/Content/ContentLabel.set_text($VBoxContainer/Content/TypeContent.get_text())



func _on_card_override():
	toggle=false
	focused=false
	StoryCard_toggled(false)

func _on_Save_pressed():
	pass




func StoryCard_toggled(button_pressed):
	if button_pressed:
		toggle=true
		$AnimationPlayer.play("toggleon")
		
		emit_signal("SendClick",self,true)
	else:
		toggle=false
		$AnimationPlayer.play("RESET")
		
		emit_signal("SendClick",self,false)


func _on_StoryCard_gui_input(event):
	if event is InputEventMouseButton and event.get_button_index()!=4 and event.get_button_index()!=5:
		if event.is_pressed():
			if not focused:
				focused=not focused
			StoryCard_toggled(focused)




func _on_goto_text_entered(new_text):
	var invalid_nodes=Array()


	var text=$VBoxContainer/OnEnd/VBoxContainer/Goto.text
	if (text.is_valid_integer()):
		var ch=$"../".get_children()
		
		if int(text)<len(ch)+1 and int(text)!=0:
			emit_signal("RefreshLines",self)
		else:
			$AnimationPlayer.play('invalid')
	else:
		$AnimationPlayer.play('invalid')

