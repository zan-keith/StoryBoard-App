extends Node2D

onready var click=false
onready var prevcard=null
signal CardOverride
func _ready():
	var children=$PanelContainer/ScrollContainer/MarginContainer/MainGrid.get_children()
	for child in children:
		child.connect("SendClick", self, "_on_card_click")


func LineConnect(obj):
	var line = Line2D.new()
	line.add_to_group("ConnectorLines")
	get_node("PanelContainer/ScrollContainer/MarginContainer/MainGrid/").add_child(line)
	
	#Set array of points to draw a line from card to "goto" step
	#other cards have more "goto" steps and that requires different approach
	if obj.is_in_group('StoryCard'):
		var goto=get_node("PanelContainer/ScrollContainer/MarginContainer/MainGrid/"+obj.name+"/VBoxContainer/OnEnd/VBoxContainer/Goto").text
		var fromobj=obj
		var toobj
		var children=$PanelContainer/ScrollContainer/MarginContainer/MainGrid.get_children()

		toobj=children[int(goto)]
		#get positions - from and to
		var from = fromobj.get_position()
		var to =toobj.get_position()
		
		var mid_point_a=from.x+fromobj.rect_size.x/2
		var mid_point_b=to.x+toobj.rect_size.x/2
		
		line.set_points([  Vector2(mid_point_a,from.y),Vector2(mid_point_a,from.y-16),Vector2(mid_point_b,to.y-16),Vector2(mid_point_b,to.y)])
	
	elif obj.is_in_group('RouterCard'):
		var goto=Array()
		var goto_panels=Array()
		var goto_panel_points=Array()
		
		var children=$PanelContainer/ScrollContainer/MarginContainer/MainGrid.get_children()
		for child in get_node("PanelContainer/ScrollContainer/MarginContainer/MainGrid/"+obj.name+"/VBoxContainer/Panel/VBoxContainer").get_children():
			if child.is_in_group('RouterGotoPanel'):
				var gototxt=child.get_node("VBoxContainer/HBoxContainer/Goto").text

				var parent=get_node("PanelContainer/ScrollContainer/MarginContainer/MainGrid/"+obj.name)
				var panel=child
				var dest=children[int(gototxt)]
				var og=Vector2((parent.get_position().x+parent.rect_size.x)-20,106+panel.rect_size.y/2)
				var a=og
				var b=a+Vector2(16,0)
				var c=b+Vector2(0,(parent.get_position().y-b.y)-20)
				var d=c+Vector2(((dest.get_position().x-parent.get_position().x)-(dest.rect_size.x/2)),0)
				var e=d+Vector2(0,20)
				goto_panel_points.append([a,b,c,d,e])
				
		var goto_array=goto
		
		var from_points=goto_panel_points
		var toobj
		
		#line.set_points([  Vector2(mid_point_a,from.y),Vector2(mid_point_a,from.y-16),Vector2(mid_point_b,to.y-16),Vector2(mid_point_b,to.y)])
		line.set_points(goto_panel_points[0])


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
		var children=$PanelContainer/ScrollContainer/MarginContainer/MainGrid.get_children()
		for child in children:
			if child.is_in_group('ConnectorLines'):
				child.queue_free()

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
		var children=$PanelContainer/ScrollContainer/MarginContainer/MainGrid.get_children()
		for child in children:
			if child.is_in_group('ConnectorLines'):
				child.queue_free()

func _on_card_click(obj,click):
	if obj.is_in_group('StoryCard'):
		StoryCardClick(click,obj.name)
	if obj.is_in_group('RouterCard'):
		RouterCardClick(click,obj.name)
