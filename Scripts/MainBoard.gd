extends Node2D

onready var click=false
onready var prevcard=null
signal CardOverride
func _ready():
	var index=1
	var children=$PanelContainer/ScrollContainer/MarginContainer/MainGrid.get_children()
	for child in children:
		
		
		child.connect("SendClick", self, "_on_card_click")
		
		if child.is_in_group('RouterCard'):
			child.connect("RefreshLines", self, "_on_refresh_lines")
			child.get_node('VBoxContainer/HBox/Index').text="# "+str(index)
		elif child.is_in_group('StoryCard'):
			child.connect("RefreshLines", self, "_on_refresh_lines")
			child.get_node("VBoxContainer/MainDetails/Index").text="# "+str(index)
		elif child.is_in_group('ChoiceCard'):
			child.connect("RefreshLines", self, "_on_refresh_lines")
			child.get_node("VBoxContainer/MainDetails/Index").text="# "+str(index)
			
		index+=1
			

func validate_goto(new_text):
	print(new_text)
	
	var cards=0
	if (str(new_text).is_valid_integer()):
		var ch=$PanelContainer/ScrollContainer/MarginContainer/MainGrid.get_children()
		for c in ch:
			if not c.is_in_group('ConnectorLines'):
				cards+=1

		if int(new_text)<=cards and not int(new_text)<=0:
			return true
		else:
			return false
		
			
func ClearLines():
	$PanelContainer/ScrollContainer/MarginContainer/PanelContainer.rect_min_size.y=0
	var lines=$PanelContainer/ScrollContainer/MarginContainer/MainGrid.get_children()
	for l in lines:
		if l.is_in_group('ConnectorLines'):
			print('cleared',l.name)
			l.queue_free()
	#print(lines)
			
func LineConnect(obj):
	ClearLines()
	
	#Set array of points to draw a line from card to "goto" step

	if obj.is_in_group('StoryCard'):
		
		var goto=get_node("PanelContainer/ScrollContainer/MarginContainer/MainGrid/"+obj.name+"/VBoxContainer/OnEnd/VBoxContainer/Goto").text

		if not validate_goto(int(goto)):
			return false

		var fromobj=obj
		var toobj
		var children=$PanelContainer/ScrollContainer/MarginContainer/MainGrid.get_children()

		toobj=children[int(goto)-1]
		#get positions - from and to
		var from = fromobj.get_position()
		var to =toobj.get_position()
		
		var mid_point_a=from.x+fromobj.rect_size.x/2
		var mid_point_b=to.x+toobj.rect_size.x/2
		
		var a=Vector2(mid_point_a,from.y)
		var b=a+Vector2(0,-10)
		var c=b+Vector2(to.x,to.y)
		var d=c+Vector2(0,10)
		
		var line = Line2D.new()
		line.width=3
		line.add_to_group("ConnectorLines")
		$PanelContainer/ScrollContainer/MarginContainer/MainGrid.add_child(line)
		
		$PanelContainer/ScrollContainer/MarginContainer/PanelContainer.rect_min_size.y=10
#		line.set_points([  Vector2(mid_point_a,from.y),Vector2(mid_point_a,from.y-10),Vector2(mid_point_b,to.y-10),Vector2(mid_point_b,to.y)])
		line.set_points([ a,b,c,d ])
		return true
	elif obj.is_in_group('RouterCard'):


		var goto_panel_points=Array([])
		
		var children=$PanelContainer/ScrollContainer/MarginContainer/MainGrid.get_children()
		
		var offset=0
		for child in get_node("PanelContainer/ScrollContainer/MarginContainer/MainGrid/"+obj.name+"/VBoxContainer/Panel/VBoxContainer").get_children():
			if child.is_in_group('RouterGotoPanel'):
				offset+=10
				var gototxt=child.get_node("VBoxContainer/HBoxContainer/Goto").text
				
				if not validate_goto(gototxt):
					#Now the animation of invalid will play in child node's script
					return false

				var ch=$PanelContainer/ScrollContainer/MarginContainer/MainGrid.get_children()
				var parent=get_node("PanelContainer/ScrollContainer/MarginContainer/MainGrid/"+obj.name)
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
			var line = Line2D.new()
			
			$PanelContainer/ScrollContainer/MarginContainer/PanelContainer.rect_min_size.y+=10
			
			line.width=3
			line.add_to_group("ConnectorLines")
			$PanelContainer/ScrollContainer/MarginContainer/MainGrid.add_child(line)
			line.set_points(pts)
		return true
		
	elif obj.is_in_group('ChoiceCard'):
		var offset=0

		var goto=Array()
		var goto_panels=Array()
		var goto_panel_points=Array()
		
		var children=$PanelContainer/ScrollContainer/MarginContainer/MainGrid.get_children()
		for child in get_node("PanelContainer/ScrollContainer/MarginContainer/MainGrid/"+obj.name+"/VBoxContainer/VBoxContainer/Choices/VBoxContainer").get_children():
			if child.is_in_group('ChoiceGotoPanel'):
				offset+=10
				var gototxt=child.get_node("VBoxContainer/HBoxContainer/Goto").text
				
				if not validate_goto(gototxt):
					return false
					
				var parent=get_node("PanelContainer/ScrollContainer/MarginContainer/MainGrid/"+obj.name)
				var subparent=get_node("PanelContainer/ScrollContainer/MarginContainer/MainGrid/"+obj.name+"/VBoxContainer/VBoxContainer/Choices")
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
			
			var line = Line2D.new()
			$PanelContainer/ScrollContainer/MarginContainer/PanelContainer.rect_min_size.y+=10
			line.width=3
			line.add_to_group("ConnectorLines")
			get_node("PanelContainer/ScrollContainer/MarginContainer/MainGrid/").add_child(line)
			line.set_points(pts)
		return true


func StoryCardClick(click,obj):
	if click and prevcard!=obj:
		if prevcard!=null:
			var prevnode=get_node("PanelContainer/ScrollContainer/MarginContainer/MainGrid/"+prevcard)
			self.connect("CardOverride", prevnode, "_on_card_override")
			emit_signal("CardOverride")
			disconnect("CardOverride", prevnode, "_on_card_override")
		prevcard=obj
		LineConnect(get_node("PanelContainer/ScrollContainer/MarginContainer/MainGrid/"+obj))
	elif click and prevcard==obj:
		prevcard=obj

	else:	#Delete previous Lines
		prevcard=null
		$PanelContainer/ScrollContainer/MarginContainer/PanelContainer.rect_min_size.y=0


func RouterCardClick(click,obj):
	if click and prevcard!=obj:
		if prevcard!=null:
			var prevnode=get_node("PanelContainer/ScrollContainer/MarginContainer/MainGrid/"+prevcard)
			self.connect("CardOverride", prevnode, "_on_card_override")
			emit_signal("CardOverride")
			disconnect("CardOverride", prevnode, "_on_card_override")
		prevcard=obj
		LineConnect(get_node("PanelContainer/ScrollContainer/MarginContainer/MainGrid/"+obj))
	elif click and prevcard==obj:
		prevcard=obj

	else:	#Delete previous Lines
		prevcard=null
		
		$PanelContainer/ScrollContainer/MarginContainer/PanelContainer.rect_min_size.y=0


func ChoiceCardClick(click,obj):
	if click and prevcard!=obj:
		if prevcard!=null:
			var prevnode=get_node("PanelContainer/ScrollContainer/MarginContainer/MainGrid/"+prevcard)
			self.connect("CardOverride", prevnode, "_on_card_override")
			emit_signal("CardOverride")
			disconnect("CardOverride", prevnode, "_on_card_override")
		prevcard=obj
		LineConnect(get_node("PanelContainer/ScrollContainer/MarginContainer/MainGrid/"+obj))
	elif click and prevcard==obj:
		prevcard=obj

	else:	#Delete previous Lines
		prevcard=null


#func _on_goto_text_entered(new_text,obj):
#	print('lol')
#
func _on_refresh_lines(obj):

	LineConnect(obj)

func _on_card_click(obj,click):
	if obj.is_in_group('StoryCard'):
		StoryCardClick(click,obj.name)
	elif obj.is_in_group('RouterCard'):
		RouterCardClick(click,obj.name)
	elif obj.is_in_group('ChoiceCard'):
		ChoiceCardClick(click,obj.name)
