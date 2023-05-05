extends PanelContainer

signal SendClick
signal RefreshLines

onready var toggle=false
onready var focused=false
func _ready():
	_on_AddChoice_pressed()
	_on_AddChoice_pressed()
	
	#$"../../../..".connect("CardOverride",self, "_on_card_override")
	pass

func _on_EditContentButton_pressed():
	$VBoxContainer/VBoxContainer/Content/TypeContent.visible=true
	$VBoxContainer/VBoxContainer/Content/TypeContent.text=$VBoxContainer/VBoxContainer/Content/ContentLabel.get_text()


func _on_SaveContentButton_pressed():
	$VBoxContainer/VBoxContainer/Content/TypeContent.visible=false
	$VBoxContainer/VBoxContainer/Content/ContentLabel.set_text($VBoxContainer/VBoxContainer/Content/TypeContent.get_text())



func _on_card_override():
	toggle=false
	focused=false
	ChoiceCard_toggled(false)

func _on_Save_pressed():
	pass




func ChoiceCard_toggled(button_pressed):
	if button_pressed:
		toggle=true
		$AnimationPlayer.play("toggleon")
		
		emit_signal("SendClick",self,true)
	else:
		toggle=false
		$AnimationPlayer.play("RESET")
		
		emit_signal("SendClick",self,false)


func _on_ChoiceCard_gui_input(event):
	if event is InputEventMouseButton:
		if event.is_pressed():
			if not focused:
				focused=not focused
			ChoiceCard_toggled(focused)

func _on_goto_text_entered(new_text,obj):
	var invalid_nodes=Array()
	
	for c in $VBoxContainer/VBoxContainer/Choices/VBoxContainer.get_children():
		var text=c.get_node('VBoxContainer/HBoxContainer/Goto').text
		if (text.is_valid_integer()):
			var ch=$"../".get_children()
			if int(text)<len(ch)+1 and not int(new_text)<=0:
				pass
			else:
				invalid_nodes.append(c)
		elif not text.is_valid_integer():
			invalid_nodes.append(c)
	if len(invalid_nodes)==0:
		emit_signal("RefreshLines",self)
	print(invalid_nodes)
	for node in invalid_nodes:
		node.get_node("AnimationPlayer").play('invalid')
	



func _on_AddChoice_pressed():
	var choice_panel = load("res://Scenes/ChoiceCard/ChoicePanel.tscn").instance()
	$VBoxContainer/VBoxContainer/Choices/VBoxContainer.add_child(choice_panel)
	choice_panel.connect("TextEntered", self, "_on_goto_text_entered")
	






