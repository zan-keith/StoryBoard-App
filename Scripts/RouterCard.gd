extends PanelContainer

signal SendClick
signal RefreshLines
signal ShowOptionsPopup

onready var toggle=false
onready var focused=false

var PreloadEditables=true

func _ready():
	if PreloadEditables:
		_on_AddGotos_pressed()

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
	if event is InputEventMouseButton and event.get_button_index()!=4 and event.get_button_index()!=5:
		if event.is_pressed():
			if not focused:
				focused=not focused
			RouterCard_toggled(focused)
		if event.get_button_index()==2 and event.is_pressed():#Right click
			emit_signal('ShowOptionsPopup',self)


func _on_goto_text_entered(new_text,obj):
	var invalid_nodes=Array()

	for c in $VBoxContainer/Panel/VBoxContainer.get_children():
		if c.is_in_group('RouterGotoPanel'):

			var text=c.get_node('VBoxContainer/HBoxContainer/Goto').text
			if (text.is_valid_integer()):
				var ch=$"../".get_children()
				
				if int(text)<len(ch)+1 and int(text)!=0:
					pass
				else:
					invalid_nodes.append(c)
			else:
				invalid_nodes.append(c)
	if len(invalid_nodes)==0:
		emit_signal("RefreshLines",self)
	for node in invalid_nodes:
		node.get_node("AnimationPlayer").play('invalid')
	

func _on_AddGotos_pressed():
	var goto_panel = load("res://Scenes/RouterCard/GotoPanel.tscn").instance()
	$VBoxContainer/Panel/VBoxContainer.add_child(goto_panel)
	get_node("VBoxContainer/Panel/VBoxContainer/"+goto_panel.name).connect("TextEntered", self, "_on_goto_text_entered")
	
	



