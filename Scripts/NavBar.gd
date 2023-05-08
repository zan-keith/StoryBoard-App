extends PanelContainer

onready var Settings_btn=$HBoxContainer/RightNav/Settings
onready var Minus_btn=$HBoxContainer/Zoom/PanelContainer/HBoxContainer/minus
onready var Plus_btn=$HBoxContainer/Zoom/PanelContainer/HBoxContainer/plus

onready var Animation_player=$AnimationPlayer


func Export():
	var FINAL_JSON={'story_line':[]}
	for card in $"../PanelContainer/ScrollContainer/Panel/MarginContainer/MainGrid".get_children():
		var Single_Card={}
		
		if card.is_in_group('StoryCard'):
			Single_Card['card_type']='StoryCard'
			Single_Card['required_vars']=[]
			Single_Card['on_end']={'set_vars':[]}

			
			var req_vars=card.get_node('VBoxContainer/OnStart/VBox/Reqs').get_children()
			var set_vars=card.get_node('VBoxContainer/OnEnd/VBoxContainer/SetVars').get_children()
			
			for vars in req_vars:
				Single_Card['required_vars'].append([vars.get_node('VarName').text,vars.get_node('VarVal').text])
			Single_Card['on_end']['goto']=int(card.get_node('VBoxContainer/OnEnd/VBoxContainer/Goto').text)
			for vars in set_vars:
				Single_Card['on_end']['set_vars'].append([vars.get_node('VarName').text,vars.get_node('VarVal').text])
			Single_Card['content']=card.get_node('VBoxContainer/Content/ContentLabel').text
		
		elif card.is_in_group('RouterCard'):
			Single_Card['card_type']='RouterCard'
		
		
		elif card.is_in_group('ChoiceCard'):
			Single_Card['card_type']='ChoiceCard'
		
		

		
		FINAL_JSON['story_line'].append(Single_Card)
	
	print(FINAL_JSON)

func _on_Settings_mouse_entered():
	Settings_btn.rect_pivot_offset=Settings_btn.rect_size/2
	Animation_player.play("clockwise_rotate")
	


func _on_Settings_mouse_exited():
	Settings_btn.rect_pivot_offset=Settings_btn.rect_size/2
	Animation_player.play("anti_clockwise_rotate")




func _on_plus_mouse_entered():
	Plus_btn.rect_pivot_offset=Plus_btn.rect_size/2
	Animation_player.play("magnify_plus")

func _on_plus_mouse_exited():
	Plus_btn.rect_pivot_offset=Plus_btn.rect_size/2
	Animation_player.play("shrink_plus")
	

func _on_minus_mouse_entered():
	Minus_btn.rect_pivot_offset=Minus_btn.rect_size/2
	Animation_player.play("magnify_minus")

	

func _on_minus_mouse_exited():
	Minus_btn.rect_pivot_offset=Minus_btn.rect_size/2
	Animation_player.play("shrink_minus")
	




func _on_LineEdit_focus_entered():
	Animation_player.play("search_bar_focus")


func _on_LineEdit_focus_exited():
	Animation_player.play("search_bar_unfocus")



func _on_ExportButton_pressed():
	$"../ExportPopupPanel".popup()
	Export()
