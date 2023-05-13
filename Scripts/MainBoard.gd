extends Control

signal CardOverride
signal ShowToast

onready var path_to_json
onready var click=false
onready var prevcard=null
export onready var latest_index=1
onready var maingrid_path="PanelContainer/ScrollContainer/Panel/MarginContainer/MainGrid/"

func _ready():
	print(path_to_json)
	
	
	if path_to_json!=null:
		LoadFromJsonFile(path_to_json)
	else:
		$AcceptDialog/VBoxContainer/Message.text="The File is corrupted or do not exist. \n Press ok to go back to Home Page"
		$AcceptDialog/AnimationPlayer.play("bgdrop")
		$AcceptDialog.visible=true
		
	$Navbar/HBoxContainer/VBoxContainer/LineEdit.text=path_to_json.get_file().get_basename()
	
	print('onstart ',$PanelContainer/ScrollContainer/Panel/MarginContainer.rect_size)

	var children=get_node(maingrid_path).get_children()
	for child in children:


		child.connect("SendClick", self, "_on_card_click")

		if child.is_in_group('RouterCard'):
			child.connect("RefreshLines", self, "_on_refresh_lines")
			child.connect('ShowOptionsPopup',self,'_on_card_right_click')
			child.get_node('VBoxContainer/HBox/Index').text=str(latest_index)
		elif child.is_in_group('StoryCard'):
			child.connect("RefreshLines", self, "_on_refresh_lines")
			child.connect('ShowOptionsPopup',self,'_on_card_right_click')
			child.get_node("VBoxContainer/MainDetails/Index").text=str(latest_index)
		elif child.is_in_group('ChoiceCard'):
			child.connect("RefreshLines", self, "_on_refresh_lines")
			child.connect('ShowOptionsPopup',self,'_on_card_right_click')
			child.get_node("VBoxContainer/MainDetails/Index").text=str(latest_index)


		latest_index+=1

func LoadFromJsonFile(path):

	var file = File.new()
	var directory = Directory.new()
	if not directory.file_exists(path):
		$AcceptDialog/VBoxContainer/Message.text="The File '"+path+"' is corrupted or do not exist. \n Press ok to go back to Home Page"
		$AcceptDialog/AnimationPlayer.play("bgdrop")
		$AcceptDialog.visible=true
		return
	file.open(path, file.READ)
	var text = file.get_as_text()
	var result_json = JSON.parse(str(text))
	if result_json.error != OK:
		print("[load_json_file] Error loading JSON file '" + str(path) + "'.")
		print("\tError: ", result_json.error)
		print("\tError Line: ", result_json.error_line)
		print("\tError String: ", result_json.error_string)
		emit_signal("ShowToast",'Corrupted Json')
		return null
		
	var dict = result_json.result
	
	
	var maingrid=get_node(maingrid_path)
	
	for card in dict['story_line']:

		if card['card_type']=='StoryCard':
			var storycard=load("res://Scenes/StoryCard.tscn").instance()
			storycard.get_node('VBoxContainer/OnStart/VBox/Reqs/VarDetails').queue_free()
			storycard.get_node('VBoxContainer/OnEnd/VBoxContainer/SetVars/VarDetails').queue_free()
			
			
			for req in card['required_vars']:
				var vars=load("res://Scenes/StoryCard/VarDetails.tscn").instance()
				vars.get_node('VarName').text=req[0]
				vars.get_node('VarVal').text=req[1]
				
				storycard.get_node('VBoxContainer/OnStart/VBox/Reqs').add_child(vars)
			
			
			for set_var in card['on_end']['set_vars']:
				var vars=load("res://Scenes/StoryCard/VarDetails.tscn").instance()
				vars.get_node('VarName').text=set_var[0]
				vars.get_node('VarVal').text=set_var[1]
				
				storycard.get_node('VBoxContainer/OnEnd/VBoxContainer/SetVars').add_child(vars)
			
			storycard.get_node('VBoxContainer/OnEnd/VBoxContainer/Goto').text=str(card['on_end']['goto'])
			storycard.get_node('VBoxContainer/Content/ContentLabel').text=str(card['content'])
			
			maingrid.add_child(storycard)
		
		elif card['card_type']=='RouterCard':
			
			var routercard=load("res://Scenes/RouterCard.tscn").instance()
			
			
			routercard.get_node('VBoxContainer/Panel/VBoxContainer/ElseGoto').text=str(card['else_goto_step'])
			
			for router in card['routers']:
				var GotoPanel=load("res://Scenes/RouterCard/GotoPanel.tscn").instance()
				GotoPanel.PreloadEditables=false
				routercard.get_node('VBoxContainer/Panel/VBoxContainer').add_child(GotoPanel)
				for req_vars in router['required_vars']:
					var vars=load("res://Scenes/StoryCard/VarDetails.tscn").instance()
					vars.get_node('VarName').text=req_vars[0]
					vars.get_node('VarVal').text=req_vars[1]
					
					GotoPanel.get_node('VBoxContainer').add_child(vars)
					GotoPanel.connect("TextEntered", routercard, "_on_goto_text_entered")
				
				routercard.add_child(GotoPanel)
				
			routercard.PreloadEditables=false
			maingrid.add_child(routercard)
			
		elif card['card_type']=='ChoiceCard':
		
			var choicecard=load("res://Scenes/ChoiceCard.tscn").instance()
			choicecard.PreloadEditables=false
			choicecard.get_node('VBoxContainer/VBoxContainer/Content/ContentLabel').text=card['pretext']
			
			for choice in card['choices']:
				var choice_panel=load("res://Scenes/ChoiceCard/ChoicePanel.tscn").instance()
				choice_panel.PreloadEditables=false
				choice_panel.get_node('VBoxContainer/HBoxContainer/Goto').text=choice['goto']
				
				for set_vars in choice['set_vars']:
					var vars=load("res://Scenes/StoryCard/VarDetails.tscn").instance()
					vars.get_node('VarName').text=set_vars[0]
					vars.get_node('VarVal').text=set_vars[1]
					
					choice_panel.get_node('VBoxContainer').add_child(vars)
				
				choicecard.get_node('VBoxContainer/VBoxContainer/Choices/VBoxContainer').add_child(choice_panel)
				choice_panel.connect("TextEntered", choicecard, "_on_goto_text_entered")
			maingrid.add_child(choicecard)
	

func validate_goto(new_text):
	
	var cards=0
	if (str(new_text).is_valid_integer()):
		var ch=get_node(maingrid_path).get_children()
		for c in ch:
			if not c.is_in_group('ConnectorLines'):
				cards+=1

		if int(new_text)<=cards and not int(new_text)<=0:
			return true
		else:
			return false
		
			
func ClearLines():
	$PanelContainer/ScrollContainer/Panel/MarginContainer/PanelContainer.rect_min_size.y=0
	var lines=get_node(maingrid_path).get_children()
	for l in lines:
		if l.is_in_group('ConnectorLines'):
			l.queue_free()
			
func LineConnect(obj):
	ClearLines()
	
	#Set array of points to draw a line from card to "goto" step
	if obj.is_in_group('StoryCard'):
		var offset=10
		var goto=get_node(maingrid_path+obj.name+"/VBoxContainer/OnEnd/VBoxContainer/Goto").text

		if not validate_goto(goto):
			return false

		var fromobj=obj
		var toobj
		var children=get_node(maingrid_path).get_children()
		toobj=children[int(goto)-1]
		
		var from = fromobj.get_position()
		var to =toobj.get_position()
		


		
		var line = load("res://Scenes/ConnectorLine.tscn").instance()
		get_node(maingrid_path).add_child(line)
		
		$PanelContainer/ScrollContainer/Panel/MarginContainer/PanelContainer.rect_min_size.y=10

		var a=Vector2(from.x+fromobj.rect_size.x/2,from.y)
		var d=Vector2(to.x+toobj.rect_size.x/2,to.y)
		
		var b=a-Vector2(0,offset)
		var c=d-Vector2(0,offset)

		line.set_points([ a,b,c,d ])
		return true
	elif obj.is_in_group('RouterCard'):


		var goto_panel_points=Array([])
		
		var children=get_node(maingrid_path).get_children()
		
		var offset=0
		for child in get_node(maingrid_path+obj.name+"/VBoxContainer/Panel/VBoxContainer").get_children():
			if child.is_in_group('RouterGotoPanel'):
				offset+=10
				var gototxt=child.get_node("VBoxContainer/HBoxContainer/Goto").text
				
				if not validate_goto(gototxt):
					#Now the animation of invalid will play in child node's script
					return false

				var ch=get_node(maingrid_path).get_children()
				var parent=get_node(maingrid_path+obj.name)
				var panel=child
				
				
				var dest=children[int(gototxt)-1]
				
				var og=Vector2((parent.get_position().x+parent.rect_size.x)-20,40+parent.rect_position.y+panel.rect_position.y+panel.rect_size.y/2)
				var a=og
				var b=a+Vector2(offset,0)
				var c=b+Vector2(0,(parent.get_position().y-b.y)-offset)
				var d=c+Vector2(((dest.get_position().x-parent.get_position().x)-(dest.rect_size.x/2)),0)
				var e=d+Vector2(0,offset)
				goto_panel_points.append([a,b,c,d,e])
				
		for pts in goto_panel_points:
#			var line = Line2D.new()
#			line.width=3
#			line.add_to_group("ConnectorLines")
			$PanelContainer/ScrollContainer/Panel/MarginContainer/PanelContainer.rect_min_size.y+=10
			
			var line = load("res://Scenes/ConnectorLine.tscn").instance()
			get_node(maingrid_path).add_child(line)
			line.set_points(pts)
		return true
		
	elif obj.is_in_group('ChoiceCard'):
		var offset=0

		var goto=Array()
		var goto_panels=Array()
		var goto_panel_points=Array()
		
		var children=get_node(maingrid_path).get_children()
		for child in get_node(maingrid_path+obj.name+"/VBoxContainer/VBoxContainer/Choices/VBoxContainer").get_children():
			if child.is_in_group('ChoiceGotoPanel'):
				offset+=10
				var gototxt=child.get_node("VBoxContainer/HBoxContainer/Goto").text
				
				if not validate_goto(gototxt):
					return false
					
				var parent=get_node(maingrid_path+obj.name)
				var subparent=get_node(maingrid_path+obj.name+"/VBoxContainer/VBoxContainer/Choices")
#				var add_btn=get_node("PanelContainer/ScrollContainer/MarginContainer/MainGrid/"+obj.name+"/VBoxContainer/VBoxContainer/Choices/VBoxContainer/Add")
				var panel=child
				var dest=children[int(gototxt)-1]
				var og=Vector2((parent.get_position().x+parent.rect_size.x)-20,30+subparent.rect_position.y+panel.rect_position.y+panel.rect_size.y/2)
				
				var a=og
				var b=a+Vector2(offset,0)
				var c=b+Vector2(0,(parent.get_position().y-b.y)-offset)
				var d=c+Vector2(((dest.get_position().x-parent.get_position().x)-(dest.rect_size.x/2)),0)
				var e=d+Vector2(0,offset)
				
				goto_panel_points.append([a,b,c,d,e])
		for pts in goto_panel_points:
			
#			var line = Line2D.new()
#			line.width=3
#			line.add_to_group("ConnectorLines")
			$PanelContainer/ScrollContainer/Panel/MarginContainer/PanelContainer.rect_min_size.y+=10
			var line = load("res://Scenes/ConnectorLine.tscn").instance()
			
			get_node(maingrid_path).add_child(line)
			line.set_points(pts)
		return true


func StoryCardClick(click,obj):
	if click and prevcard!=obj:
		if prevcard!=null:
			var prevnode=get_node(maingrid_path+prevcard)
			self.connect("CardOverride", prevnode, "_on_card_override")
			emit_signal("CardOverride")
			disconnect("CardOverride", prevnode, "_on_card_override")
		prevcard=obj
		LineConnect(get_node(maingrid_path+obj))
	elif click and prevcard==obj:
		var prevnode=get_node(maingrid_path+prevcard)
		self.connect("CardOverride", prevnode, "_on_card_override")
		emit_signal("CardOverride")
		disconnect("CardOverride", prevnode, "_on_card_override")
		prevcard=null
		
	else:
		prevcard=null
		$PanelContainer/ScrollContainer/Panel/MarginContainer/PanelContainer.rect_min_size.y=0


func RouterCardClick(click,obj):
	if click and prevcard!=obj:
		if prevcard!=null:
			var prevnode=get_node(maingrid_path+prevcard)
			self.connect("CardOverride", prevnode, "_on_card_override")
			emit_signal("CardOverride")
			disconnect("CardOverride", prevnode, "_on_card_override")
		prevcard=obj
		LineConnect(get_node(maingrid_path+obj))
	elif click and prevcard==obj:
		var prevnode=get_node(maingrid_path+prevcard)
		self.connect("CardOverride", prevnode, "_on_card_override")
		emit_signal("CardOverride")
		disconnect("CardOverride", prevnode, "_on_card_override")
		prevcard=null

	else:	#Delete previous Lines
		prevcard=null
		
		$PanelContainer/ScrollContainer/Panel/MarginContainer/PanelContainer.rect_min_size.y=0


func ChoiceCardClick(click,obj):
	if click and prevcard!=obj:
		if prevcard!=null:
			var prevnode=get_node(maingrid_path+prevcard)
			self.connect("CardOverride", prevnode, "_on_card_override")
			emit_signal("CardOverride")
			disconnect("CardOverride", prevnode, "_on_card_override")
		prevcard=obj
		LineConnect(get_node(maingrid_path+obj))
	elif click and prevcard==obj:
		var prevnode=get_node(maingrid_path+prevcard)
		self.connect("CardOverride", prevnode, "_on_card_override")
		emit_signal("CardOverride")
		disconnect("CardOverride", prevnode, "_on_card_override")
		prevcard=null
		

	else:
		prevcard=null


func _on_refresh_lines(obj):
	LineConnect(obj)

func _on_card_click(obj,click):
	if obj.is_in_group('StoryCard'):
		StoryCardClick(click,obj.name)
	elif obj.is_in_group('RouterCard'):
		RouterCardClick(click,obj.name)
	elif obj.is_in_group('ChoiceCard'):
		ChoiceCardClick(click,obj.name)


func _on_card_right_click(obj):
	
	print(path_to_json)
	if prevcard!=null:
		$PopupMenu.popup()

		
		if obj.get_index()+1==len($PanelContainer/ScrollContainer/Panel/MarginContainer/MainGrid.get_children()):
			$PopupMenu.set_position(obj.get_global_position()-Vector2($PopupMenu.rect_size.x+5,0))
		else:
			$PopupMenu.set_position(obj.get_global_position()+Vector2(obj.rect_size.x,0))
	else:
		$PopupMenu.visible=false
		
func Tidy_Order(remove_node):
	var index=1
	var children=$PanelContainer/ScrollContainer/Panel/MarginContainer/MainGrid.get_children()
	children.erase(remove_node)
	for child in children:

		if child.is_in_group('RouterCard'):
			child.get_node('VBoxContainer/HBox/Index').text=str(index)
		elif child.is_in_group('StoryCard'):
			child.get_node("VBoxContainer/MainDetails/Index").text=str(index)
		elif child.is_in_group('ChoiceCard'):
			child.get_node("VBoxContainer/MainDetails/Index").text=str(index)

		index+=1
	latest_index=index-1
	

func _on_Popup_Remove_Button_pressed():
	if prevcard!=null:
		get_node(maingrid_path+prevcard).queue_free()
		Tidy_Order(get_node(maingrid_path+prevcard))
		ClearLines()
		$PopupMenu.visible=false
		prevcard=null
	else:
		emit_signal("ShowToast",'Invalid Card - Select a card before using options')
		$PopupMenu.visible=false


func _on_Popup_Move_Card_text_entered(indx):
	if prevcard!=null:
		if validate_goto(indx):
			$PanelContainer/ScrollContainer/Panel/MarginContainer/MainGrid.move_child(get_node(maingrid_path+prevcard),int(indx)-1)
			
		else:
			emit_signal("ShowToast",'The Index provided does not exist')
	else:
		emit_signal("ShowToast",'Invalid Card - To Move a card select a card')



func _on_Popup_Add_Button_pressed():
	$PopupMenu/PopupMenu.set_global_position($PopupMenu/VBoxContainer/AddCard.get_global_position()+Vector2($PopupMenu/VBoxContainer/AddCard.rect_size.x+10,0))
	$PopupMenu/PopupMenu.popup()
	

func _on_MainGrid_item_rect_changed():
	$PanelContainer/ScrollContainer/Panel.set_custom_minimum_size($PanelContainer/ScrollContainer/Panel/MarginContainer/MainGrid.get_size()+$PanelContainer/ScrollContainer/Panel/MarginContainer/PanelContainer.get_size())





func _on_Project_Title_LineEdit_text_entered(new_text):
	var dir = Directory.new()
	dir.rename(path_to_json, path_to_json.get_base_dir()+'\\'+new_text+'.json')
	emit_signal("ShowToast",'Renamed File to'+new_text)


func _on_Return_To_Home_confirmed():
	get_tree().change_scene("res://Scenes/HomeScreen/HomeScreen.tscn")


