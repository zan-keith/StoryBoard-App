extends PanelContainer

signal SendClick
signal ChangeConnectorLines

onready var toggle=false
onready var focused=false


func _on_EditButton_pressed():
	$VBoxContainer/Content/TypeContent.visible=true
	$VBoxContainer/Content/TypeContent.text=$VBoxContainer/Content/ContentLabel.get_text()


func _on_SaveContentButton_pressed():
	$VBoxContainer/Content/TypeContent.visible=false
	$VBoxContainer/Content/ContentLabel.set_text($VBoxContainer/Content/TypeContent.get_text())



func _on_card_override():
	toggle=false
	focused=false
	RouterCard_toggled(false)

func _on_Save_pressed():
	pass




func RouterCard_toggled(button_pressed):
	if button_pressed:
		toggle=true
		$AnimationPlayer.play("toggleon")
		
		emit_signal("SendClick",self,true)
	else:
		toggle=false
		$AnimationPlayer.play("RESET")
		
		emit_signal("SendClick",self,false)

func _on_RouterCard_gui_input(event):
	if event is InputEventMouseButton:
		if event.is_pressed():
			focused=not focused
			RouterCard_toggled(focused)


func _on_Goto_text_entered(new_text):
	if (new_text.is_valid_integer()):
		var l=1
		var ch=$"../".get_children()
		for c in ch:
			if c.is_in_group('StoryCard'):
				l+=1
		if int(new_text)<l:
			emit_signal('ChangeConnectorLines')
			print("Goto Step Exists")


func _on_AddGotos_pressed():
	var goto_panel = load("res://Scenes/RouterCard/GotoPanel.tscn").instance()
	$VBoxContainer/Panel/VBoxContainer/.add_child(goto_panel)

