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
	line.add_to_group("ConnecterLines")
	get_node("PanelContainer/ScrollContainer/MarginContainer/MainGrid/").add_child(line)
	
	#Set array of points to draw a line from card to "goto" step
	#other cards have more "goto" steps and that requires different approach
	if obj.is_in_group('StoryCard'):
		var goto=get_node("PanelContainer/ScrollContainer/MarginContainer/MainGrid/"+obj.name+"/VBoxContainer/OnEnd/VBoxContainer/Goto").text
		var fromobj=obj
		var toobj
		goto=2
		var children=$PanelContainer/ScrollContainer/MarginContainer/MainGrid.get_children()

#		print(children)
		toobj=children[int(goto)]
#		print(fromobj,toobj)
		#get positions - from and to
		var from = fromobj.get_position()
		var to =toobj.get_position()
		print(from,to)
		
		var mid_point_a=from.x+fromobj.rect_size.x/2
		var mid_point_b=to.x+toobj.rect_size.x/2
		
		line.set_points([  Vector2(mid_point_a,from.y),Vector2(mid_point_a,from.y-16),Vector2(mid_point_b,to.y-16),Vector2(mid_point_b,to.y)])
		#line.set_points([  Vector2(1020,-4),Vector2(204, 0)])
		

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

#		$PanelContainer/Line2D.visible=true
	else:
		prevcard=null
		var children=$PanelContainer/ScrollContainer/MarginContainer/MainGrid.get_children()
		for child in children:
			if child.is_in_group('ConnecterLines'):
				child.queue_free()
#		$PanelContainer/Line2D.visible=false


func _on_card_click(obj,click):
	if obj.is_in_group('StoryCard'):
		StoryCardClick(click,obj.name)
	
